<?php

namespace App\Services;

use App\Models\{Product,PurchaseOrder,SalesOrder,PurchaseOrderItem,SalesOrderItem};
use App\Models\AuditLog;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class OrderService
{
    public function __construct(private StockService $stock) {}

    private function ensure(bool $valid, string $message): void
    {
        if (! $valid) throw ValidationException::withMessages(['status'=>$message]);
    }
    private function audit(string $action, string $type, int $id, int $userId): void
    {
        AuditLog::create(['user_id'=>$userId,'action'=>$action,'entity_type'=>$type,'entity_id'=>$id,'ip_address'=>request()->ip()]);
    }

    /** Creates a complete order with price snapshots, one SKU per line. */
    public function create(string $kind, int $partyId, array $lines, int $userId, bool $confirm=false, ?string $note=null): int
    {
        return DB::transaction(function () use($kind,$partyId,$lines,$userId,$confirm,$note) {
            $purchase=$kind==='purchase';
            $ids=array_map(fn($l)=>(int)$l['product_id'],$lines);
            $this->ensure(count($ids)>0 && count($ids)===count(array_unique($ids)), 'Mỗi SKU chỉ được xuất hiện một lần trong đơn.');
            $products=Product::query()->whereIn('id',$ids)->where('status','active')->get()->keyBy('id');
            $this->ensure(count($products)===count($ids),'Sản phẩm không hợp lệ hoặc ngừng kinh doanh.');
            $data=['code'=>($purchase?'PO-':'SO-').strtoupper((string)Str::ulid()),
                $purchase?'supplier_id':'customer_id'=>$partyId,'status'=>'draft',
                'created_by'=>$userId,'total_amount'=>0,'note'=>$note];
            $order=$purchase?PurchaseOrder::create($data):SalesOrder::create($data);
            $totalCents=0;
            foreach ($lines as $line) {
                $product=$products[(int)$line['product_id']];$qty=(int)$line['quantity'];
                $this->ensure($qty>0,'Số lượng phải lớn hơn 0.');
                $price=(string)($purchase?$product->cost_price:$product->selling_price);
                $totalCents += (int) round(((float) $price) * 100) * $qty;
                $attrs=['product_id'=>$product->id,'quantity'=>$qty,
                    $purchase?'unit_cost':'unit_price'=>$price];
                $order->items()->create($attrs);
            }
            $order->update(['total_amount'=>number_format($totalCents / 100, 2, '.', '')]);
            if (!$purchase && $confirm) $this->transition('sale',$order->id,'confirm',$userId);
            $this->audit(($purchase?'purchase':'sale').'.create',$purchase?'PurchaseOrder':'SalesOrder',$order->id,$userId);
            return $order->id;
        },3);
    }

    /** Only Draft orders may be edited. Price snapshot refreshes on draft edit. */
    public function editDraft(string $kind, int $id, int $partyId, array $lines, int $userId, ?string $note): void
    {
        DB::transaction(function() use($kind,$id,$partyId,$lines,$userId,$note){
            $purchase=$kind==='purchase';
            $model=$purchase?PurchaseOrder::class:SalesOrder::class;
            $order=$model::query()->lockForUpdate()->findOrFail($id);
            $this->ensure($order->status==='draft', 'Chỉ sửa đơn đang ở trạng thái nháp.');
            $this->ensure((int)$order->created_by===$userId || auth()->user()->hasAnyRole(['admin']), 'Chỉ người lập đơn được sửa bản nháp.');
            $ids=array_map(fn($l)=>(int)$l['product_id'],$lines);
            $this->ensure(count($ids)>0&&count($ids)===count(array_unique($ids)),'SKU trong đơn không được trùng.');
            $products=Product::whereIn('id',$ids)->where('status','active')->get()->keyBy('id');
            $this->ensure($products->count()===count($ids),'Có sản phẩm không hợp lệ.');
            $order->items()->delete();$totalCents=0;
            foreach($lines as $line){
                $product=$products[(int)$line['product_id']];$quantity=(int)$line['quantity'];
                $this->ensure($quantity>0,'Số lượng phải dương.');
                $price=(string)($purchase?$product->cost_price:$product->selling_price);
                $totalCents += (int) round(((float) $price) * 100) * $quantity;
                $order->items()->create(['product_id'=>$product->id,'quantity'=>$quantity,
                    $purchase?'unit_cost':'unit_price'=>$price]);
            }
            $order->update([$purchase?'supplier_id':'customer_id'=>$partyId,'note'=>$note,'total_amount'=>number_format($totalCents / 100, 2, '.', '')]);
            $this->audit(($purchase?'purchase':'sale').'.edit',$purchase?'PurchaseOrder':'SalesOrder',$id,$userId);
        },3);
    }

    /** Transaction + row locking prevent duplicate receipts and shipments. */
    public function transition(string $kind, int $id, string $action, int $userId, ?string $reason=null): void
    {
        DB::transaction(function () use($kind,$id,$action,$userId,$reason) {
            $purchase=$kind==='purchase';
            $order=$purchase?PurchaseOrder::query()->lockForUpdate()->findOrFail($id)
                :SalesOrder::query()->lockForUpdate()->findOrFail($id);
            $status=$order->status;$update=[];
            if ($purchase) {
                switch ($action) {
                    case 'submit':$this->ensure($status==='draft','Chỉ gửi duyệt đơn nháp.');$update=['status'=>'pending_approval'];break;
                    case 'approve':
                        $this->ensure($status==='pending_approval','Đơn chưa chờ duyệt.');
                        $this->ensure((int)$order->created_by!==$userId,'Không thể tự duyệt đơn do chính mình lập.');
                        $update=['status'=>'approved','approved_by'=>$userId,'approved_at'=>now()];break;
                    case 'reject':$this->ensure($status==='pending_approval','Chỉ từ chối đơn chờ duyệt.');
                        $this->ensure(trim((string)$reason)!=='','Cần lý do từ chối.');
                        $update=['status'=>'rejected','rejected_by'=>$userId,'rejected_at'=>now(),'rejection_reason'=>$reason];break;
                    case 'receive':
                        $this->ensure($status==='approved','Chỉ nhập kho cho PO đã phê duyệt và chưa nhận.');
                        foreach ($order->items()->orderBy('product_id')->get() as $line) {
                            $inventory=$this->stock->locked((int)$line->product_id);
                            $this->stock->move($inventory,(int)$line->quantity,'purchase_receipt','purchase_order_item_id',$line->id,$userId);
                        }
                        $update=['status'=>'received','received_by'=>$userId,'received_at'=>now()];break;
                    case 'complete':$this->ensure($status==='received','Chỉ hoàn tất hồ sơ đã nhận đủ hàng.');$update=['status'=>'completed','completed_at'=>now()];break;
                    case 'cancel':$this->ensure(in_array($status,['draft','pending_approval','approved'],true),'Không thể hủy đơn đã nhận hàng.');$update=['status'=>'cancelled','cancelled_by'=>$userId,'cancelled_at'=>now()];break;
                    default:abort(404);
                }
            } else {
                switch ($action) {
                    case 'confirm':
                        $this->ensure($status==='draft','Chỉ xác nhận đơn nháp.');
                        foreach ($order->items()->orderBy('product_id')->get() as $line) {
                            $available=$this->stock->locked((int)$line->product_id);
                            $this->ensure($available->qty_on_hand >= $line->quantity,'Không đủ tồn để xác nhận: SKU #'.$line->product_id);
                        }
                        $update=['status'=>'confirmed','confirmed_at'=>now()];break;
                    case 'fulfill':
                        $this->ensure($status==='confirmed','Chỉ xuất kho đơn Confirmed chưa xuất.');
                        foreach ($order->items()->orderBy('product_id')->get() as $line) {
                            $inventory=$this->stock->locked((int)$line->product_id);
                            $this->stock->move($inventory,-(int)$line->quantity,'sales_issue','sales_order_item_id',$line->id,$userId);
                        }
                        $update=['status'=>'completed','completed_at'=>now()];break;
                    case 'cancel':$this->ensure(in_array($status,['draft','confirmed'],true),'Không thể hủy đơn đã xuất.');$update=['status'=>'cancelled','cancelled_by'=>$userId,'cancelled_at'=>now()];break;
                    default:abort(404);
                }
            }
            $order->update($update);
            $this->audit(($purchase?'purchase':'sale').'.'.$action,$purchase?'PurchaseOrder':'SalesOrder',$order->id,$userId);
        },3);
    }
}
