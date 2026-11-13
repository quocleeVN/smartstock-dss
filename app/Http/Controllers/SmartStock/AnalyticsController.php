<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\{Product,Inventory,InventoryAlert,PurchaseRecommendation,PurchaseOrder,ForecastRun,DemandForecast,Supplier};
use App\Services\{DecisionService,OrderService};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;

class AnalyticsController extends Controller
{
    public function __construct(private DecisionService $service) {}
    public function dashboard()
    {
        return Inertia::render('smartstock/dashboard',['metrics'=>[
            'revenue'=>(float)DB::table('sales_orders')->where('status','completed')->sum('total_amount'),
            'completed_sales'=>(int)DB::table('sales_orders')->where('status','completed')->count(),
            'pending_purchases'=>(int)DB::table('purchase_orders')->where('status','pending_approval')->count(),
            'products'=>(int)Product::where('status','active')->count(),
            'onhand'=>(int)Inventory::sum('qty_on_hand'),
        ],'daily'=>DB::table('sales_orders')->where('status','completed')
                ->where('completed_at','>=',now()->subDays(29))
                ->selectRaw('DATE(completed_at) as day, SUM(total_amount) as revenue')
                ->groupByRaw('DATE(completed_at)')->orderBy('day')->get(),
           'recent'=>DB::table('sales_orders')->select('id','code','status','total_amount','created_at')->latest('id')->limit(8)->get(),
           'low'=>collect($this->service->inventoryInfo())->filter(fn($r)=>($r['status']??'normal')!=='normal')->values()->take(8)]);
    }
    public function analysis(Request $request)
    {
        $from=$request->query('from');$to=$request->query('to');
        $request->validate(['from'=>['nullable','date'],'to'=>['nullable','date','after_or_equal:from']]);
        return Inertia::render('smartstock/analytics',['abc'=>$this->service->abc($from,$to),
            'stocks'=>$this->service->inventoryInfo(),'from'=>$from,'to'=>$to,
            'products'=>Product::where('status','active')->get(['id','sku','name']),
            'forecasts'=>ForecastRun::orderByDesc('id')->limit(10)->get(),
            'forecast_lines'=>DemandForecast::orderByDesc('id')->limit(30)->get(),
            'suppliers'=>Supplier::where('status','active')->get(['id','name']),
            'recommendations'=>PurchaseRecommendation::where('status','proposed')->orderByDesc('id')->limit(30)->get(),
        ]);
    }
    public function scan()
    {
        return back()->with('success','Đã cập nhật cảnh báo. Cảnh báo mới: '.$this->service->scan());
    }
    public function forecast(Request $request)
    {
        $data=$request->validate(['product_id'=>['required','exists:products,id']]);
        $this->service->forecast((int)$data['product_id'],(int)$request->user()->id);
        return back()->with('success','Đã tạo dự báo 4 tuần (MA3).');
    }
    public function recommendation(Request $request)
    {
        $data=$request->validate(['inventory_id'=>['required','exists:inventories,id']]);
        $row=collect($this->service->inventoryInfo())->firstWhere('id',(int)$data['inventory_id']);
        if (!$row || !($row['configured']??false) || ($row['suggested']??0)<=0) throw ValidationException::withMessages(['quantity'=>'Chưa đủ điều kiện đề xuất.']);
        PurchaseRecommendation::create(['inventory_id'=>$row['id'],'qty_on_hand_snapshot'=>$row['onhand'],
            'incoming_qty_snapshot'=>$row['incoming'],'reorder_point_snapshot'=>$row['reorder_point'],
            'suggested_qty'=>$row['suggested'],'basis'=>'historical_average','status'=>'proposed','created_by'=>$request->user()->id]);
        return back()->with('success','Đã lưu đề xuất mua hàng.');
    }
    /** Purchase staff may convert a transparent suggestion to a regular PO Draft. */
    public function convert(Request $request, OrderService $orders)
    {
        abort_unless($request->user()->hasAnyRole(['purchasing','admin']),403);
        $data=$request->validate(['recommendation_id'=>['required','exists:purchase_recommendations,id'],
            'supplier_id'=>['required','exists:suppliers,id']]);
        DB::transaction(function()use($data,$request,$orders){
            $rec=PurchaseRecommendation::query()->lockForUpdate()->findOrFail($data['recommendation_id']);
            if($rec->status!=='proposed') throw ValidationException::withMessages(['recommendation'=>'Đề xuất này đã được xử lý.']);
            $inv=Inventory::findOrFail($rec->inventory_id);
            $id=$orders->create('purchase',(int)$data['supplier_id'],[
                ['product_id'=>$inv->product_id,'quantity'=>$rec->suggested_qty],
            ],(int)$request->user()->id);
            $rec->update(['purchase_order_id'=>$id,'status'=>'converted']);
        });
        return back()->with('success','Đã chuyển đề xuất thành PO Draft. Cần gửi duyệt theo quy trình.');
    }
    public function export(Request $request)
    {
        $request->validate(['from'=>['nullable','date'],'to'=>['nullable','date','after_or_equal:from']]);
        $rows=$this->service->abc($request->query('from'),$request->query('to'));
        return response()->streamDownload(function()use($rows){
            $o=fopen('php://output','w');fwrite($o,"\xEF\xBB\xBF");
            fputcsv($o,['SKU','Sản phẩm','Số lượng bán','Doanh thu','Tỷ trọng %','Tích lũy %','Nhóm ABC']);
            foreach($rows as $row){
                $clean=fn($v)=>is_string($v)&&preg_match('/^[=+@\x2d\t\r]/u',$v)?"'".$v:$v;
                fputcsv($o,[$clean($row['sku']),$clean($row['name']),$row['sold'],$row['revenue'],$row['percent'],$row['cumulative'],$row['group']]);
            }
            fclose($o);
        },'smartstock-abc-'.now()->format('Ymd').'.csv',['Content-Type'=>'text/csv; charset=UTF-8']);
    }
}
