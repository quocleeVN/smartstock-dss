<?php

namespace App\Services;

use App\Models\{Inventory,InventoryAlert,InventoryPolicy,PurchaseRecommendation,Product,SalesOrderItem,ForecastRun,DemandForecast};
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Carbon;
use Illuminate\Support\Str;

class DecisionService
{
    public function demand(int $productId, int $days=30): float
    {
        $qty=DB::table('sales_order_items as i')->join('sales_orders as o','o.id','=','i.sales_order_id')
            ->where('o.status','completed')->where('i.product_id',$productId)
            ->where('o.completed_at','>=',now()->subDays($days))->sum('i.quantity');
        return (int)$qty/max(1,$days);
    }
    public function incoming(int $productId): int
    {
        return (int) DB::table('purchase_order_items as i')->join('purchase_orders as o','o.id','=','i.purchase_order_id')
            ->where('o.status','approved')->where('i.product_id',$productId)->sum('i.quantity');
    }
    public function inventoryInfo(): array
    {
        $output=[];
        foreach (Inventory::query()->join('products as p','p.id','=','inventories.product_id')->select('inventories.*','p.name as product_name','p.sku')->orderBy('p.name')->get() as $item) {
            $policy=InventoryPolicy::where('inventory_id',$item->id)->first();
            if (!$policy) { $output[]=['id'=>$item->id,'product_id'=>$item->product_id,'sku'=>$item->sku,'name'=>$item->product_name,'onhand'=>$item->qty_on_hand,'configured'=>false];continue; }
            $d=$this->demand((int)$item->product_id,(int)$policy->demand_window_days);
            $rop=(int)ceil($d*$policy->lead_time_days+$policy->safety_stock_qty);
            $incoming=$this->incoming((int)$item->product_id);
            $target=(int)ceil($d*($policy->lead_time_days+$policy->target_cover_days)+$policy->safety_stock_qty);
            $q=max(0,$target-(int)$item->qty_on_hand-$incoming);
            $output[]=['id'=>$item->id,'product_id'=>$item->product_id,'sku'=>$item->sku,'name'=>$item->product_name,'onhand'=>$item->qty_on_hand,
                'configured'=>true,'demand'=>round($d,3),'lead'=>$policy->lead_time_days,'safety'=>$policy->safety_stock_qty,
                'reorder_point'=>$rop,'incoming'=>$incoming,'target'=>$target,'suggested'=>$q,
                'status'=>(int)$item->qty_on_hand===0?'out_of_stock':((int)$item->qty_on_hand<=$rop?'low_stock':'normal')];
        }
        return $output;
    }
    public function scan(): int
    {
        $count=0;
        foreach ($this->inventoryInfo() as $row) {
            if (!$row['configured']) continue;
            $kind=$row['status'];
            InventoryAlert::where('inventory_id',$row['id'])->where('status','open')
                ->when($kind!=='normal',fn($q)=>$q->where('alert_type','!=',$kind))->update(['status'=>'resolved','resolved_at'=>now()]);
            if ($kind==='normal') {InventoryAlert::where('inventory_id',$row['id'])->where('status','open')->update(['status'=>'resolved','resolved_at'=>now()]);continue;}
            $alert=InventoryAlert::where('inventory_id',$row['id'])->where('alert_type',$kind)->where('status','open')->first();
            if ($alert) $alert->update(['last_detected_at'=>now(),'qty_at_detection'=>$row['onhand'],'threshold_qty'=>$row['reorder_point']]);
            else {
                InventoryAlert::create(['inventory_id'=>$row['id'],'alert_type'=>$kind,'status'=>'open',
                    'qty_at_detection'=>$row['onhand'],'threshold_qty'=>$row['reorder_point'],
                    'first_detected_at'=>now(),'last_detected_at'=>now()]);
                $managers=DB::table('user_roles as ur')->join('roles as r','r.id','=','ur.role_id')
                    ->whereIn('r.code',['manager','admin'])->distinct()->pluck('ur.user_id');
                foreach ($managers as $uid) DB::table('notifications')->insert([
                    'id'=>(string)Str::uuid(),'type'=>'stock_alert','notifiable_type'=>'App\\Models\\User',
                    'notifiable_id'=>$uid,'data'=>json_encode(['title'=>'Cảnh báo tồn kho',
                        'message'=>$row['name'].' - '.($kind==='out_of_stock'?'Hết hàng':'Sắp hết hàng'),
                        'onhand'=>$row['onhand'],'reorder_point'=>$row['reorder_point']],JSON_UNESCAPED_UNICODE),
                    'created_at'=>now(),'updated_at'=>now(),
                ]);
                $count++;
            }
        }
        return $count;
    }
    public function abc(?string $from=null,?string $to=null): array
    {
        $q=DB::table('sales_order_items as i')->join('sales_orders as o','o.id','=','i.sales_order_id')
            ->join('products as p','p.id','=','i.product_id')->where('o.status','completed');
        if ($from) $q->whereDate('o.completed_at','>=',$from);
        if ($to) $q->whereDate('o.completed_at','<=',$to);
        $rows=$q->groupBy('p.id','p.sku','p.name')->select('p.id','p.sku','p.name')
            ->selectRaw('SUM(i.line_total) AS revenue, SUM(i.quantity) AS sold')->orderByDesc('revenue')->get();
        $total=(float)$rows->sum('revenue');$run=0;
        return $rows->map(function($r) use($total,&$run) {
            $before=$run;$run+=(float)$r->revenue;$share=$total>0?$run/$total*100:0;
            return ['sku'=>$r->sku,'name'=>$r->name,'sold'=>$r->sold,'revenue'=>(float)$r->revenue,
                'percent'=>round($total?100*(float)$r->revenue/$total:0,2),'cumulative'=>round($share,2),
                'group'=>$total>0 && $before/$total <= 0.8?'A':($total>0 && $before/$total <= 0.95?'B':'C')];
        })->all();
    }
    public function forecast(int $productId, int $userId): ForecastRun
    {
        $first=DB::table('sales_orders as o')->join('sales_order_items as i','i.sales_order_id','=','o.id')
            ->where('o.status','completed')->where('i.product_id',$productId)->min('o.completed_at');
        if (!$first) throw ValidationException::withMessages(['forecast'=>'Không có lịch sử bán hàng.']);
        $start=Carbon::parse($first)->startOfWeek();$end=now()->startOfWeek();
        $weeks=$start->diffInWeeks($end);
        if ($weeks<8) throw ValidationException::withMessages(['forecast'=>'Cần ít nhất 8 tuần lịch sử đã qua để dự báo.']);
        $weekly=[];
        for ($w=0;$w<$weeks;$w++) {
            $from=$start->copy()->addWeeks($w);$until=$from->copy()->addWeek();
            $weekly[]=(int)DB::table('sales_order_items as i')->join('sales_orders as o','o.id','=','i.sales_order_id')
                ->where('o.status','completed')->where('i.product_id',$productId)->where('o.completed_at','>=',$from)
                ->where('o.completed_at','<',$until)->sum('i.quantity');
        }
        // 3-period moving average and chronological one-step backtest.
        $errors=[];
        for ($i=3;$i<count($weekly);$i++) $errors[]=abs($weekly[$i]-array_sum(array_slice($weekly,$i-3,3))/3);
        $mae=count($errors)?array_sum($errors)/count($errors):null;
        return DB::transaction(function()use($productId,$userId,$start,$end,$weekly,$mae){
            $run=ForecastRun::create(['product_id'=>$productId,'method'=>'moving_average','granularity'=>'weekly',
                'train_from'=>$start->toDateString(),'train_to'=>$end->copy()->subDay()->toDateString(),
                'mae'=>$mae,'status'=>'completed','created_by'=>$userId,'generated_at'=>now()]);
            $base=$weekly;
            for($i=0;$i<4;$i++){
                $prediction=max(0,round(array_sum(array_slice($base,-3))/3,3));$from=$end->copy()->addWeeks($i);
                DemandForecast::create(['forecast_run_id'=>$run->id,'period_start'=>$from->toDateString(),
                    'period_end'=>$from->copy()->addDays(6)->toDateString(),'predicted_qty'=>$prediction]);
                $base[]=$prediction;
            }
            return $run;
        });
    }
}
