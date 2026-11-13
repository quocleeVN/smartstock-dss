<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\{PurchaseOrder,SalesOrder,Product,Customer,Supplier};
use App\Services\OrderService;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class OrderController extends Controller
{
    public function __construct(private OrderService $service) {}
    private function isPurchase(string $kind): bool { abort_unless(in_array($kind,['purchase','sale']),404);return $kind==='purchase'; }
    public function index(Request $request,string $kind)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['purchasing','warehouse','manager','admin']:['sales','warehouse','manager','admin']),403);
        $model=$purchase?PurchaseOrder::class:SalesOrder::class;
        $query=$model::query()->latest('id');
        if ($request->filled('status'))$query->where('status',$request->query('status'));
        return Inertia::render('smartstock/orders',['kind'=>$kind,'orders'=>$query->paginate(15)->withQueryString(),
            'status'=>$request->query('status','')]);
    }
    /** Options for the order form. Inventory is advisory only; the service re-checks stock. */
    private function productOptions(bool $purchase)
    {
        $products=Product::where('status','active')->orderBy('name')
            ->get($purchase?['id','sku','name','cost_price','selling_price']:['id','sku','name','selling_price']);
        if (! $purchase) {
            $available=\Illuminate\Support\Facades\DB::table('inventories as i')
                ->join('warehouses as w','w.id','=','i.warehouse_id')
                ->where('w.code','MAIN')->pluck('i.qty_on_hand','i.product_id');
            foreach ($products as $product) $product->setAttribute('available_qty', (int) ($available[$product->id] ?? 0));
        }
        return $products;
    }

    public function make(Request $request,string $kind)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['purchasing','admin']:['sales','admin']),403);
        return Inertia::render('smartstock/order-create',['kind'=>$kind,'pos'=>!$purchase && $request->boolean('pos'),
            'parties'=>($purchase?Supplier::class:Customer::class)::where('status','active')->orderBy('name')->get(['id','name']),
            'products'=>$this->productOptions($purchase),
            'editing'=>null,
        ]);
    }
    public function edit(Request $request,string $kind,int $id)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['admin','purchasing']:['admin','sales']),403);
        $order=($purchase?PurchaseOrder::class:SalesOrder::class)::with('items')->findOrFail($id);
        abort_unless($order->status==='draft',404);
        abort_unless((int)$order->created_by===(int)$request->user()->id || $request->user()->hasAnyRole(['admin']),403);
        return Inertia::render('smartstock/order-create',['kind'=>$kind,'pos'=>false,
            'editing'=>['id'=>$order->id,'party_id'=>$purchase?$order->supplier_id:$order->customer_id,
                'note'=>$order->note,'items'=>$order->items->map(fn($i)=>['product_id'=>$i->product_id,'quantity'=>$i->quantity])],
            'parties'=>($purchase?Supplier::class:Customer::class)::where('status','active')->orderBy('name')->get(['id','name']),
            'products'=>$this->productOptions($purchase),
        ]);
    }
    public function update(Request $request,string $kind,int $id)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['admin','purchasing']:['admin','sales']),403);
        $data=$request->validate([
            'party_id'=>['required','integer',Rule::exists($purchase?'suppliers':'customers','id')->where('status','active')],
            'items'=>['required','array','min:1','max:100'],
            'items.*.product_id'=>['required','integer','exists:products,id','distinct'],
            'items.*.quantity'=>['required','integer','min:1','max:1000000'],
            'note'=>['nullable','string','max:2000'],
        ]);
        $this->service->editDraft($kind,$id,(int)$data['party_id'],$data['items'],(int)$request->user()->id,$data['note']??null);
        return redirect('/'.$kind.'-orders/'.$id)->with('success','Đã cập nhật đơn nháp.');
    }
    public function store(Request $request,string $kind)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['purchasing','admin']:['sales','admin']),403);
        $table=$purchase?'suppliers':'customers';
        $data=$request->validate([
            'party_id'=>['required','integer',Rule::exists($table,'id')->where('status','active')],
            'items'=>['required','array','min:1','max:100'], 'items.*.product_id'=>['required','integer','exists:products,id','distinct'],
            'items.*.quantity'=>['required','integer','min:1','max:1000000'],
            'confirm'=>['sometimes','boolean'], 'note'=>['nullable','string','max:2000'],
        ]);
        $id=$this->service->create($kind,(int)$data['party_id'],$data['items'],(int)$request->user()->id,!$purchase && (bool)($data['confirm']??false),$data['note']??null);
        return redirect('/'.$kind.'-orders/'.$id)->with('success','Đã tạo đơn thành công.');
    }
    public function show(Request $request,string $kind,int $id)
    {
        $purchase=$this->isPurchase($kind);
        abort_unless($request->user()->hasAnyRole($purchase?['purchasing','warehouse','manager','admin']:['sales','warehouse','manager','admin']),403);
        $model=$purchase?PurchaseOrder::class:SalesOrder::class;
        $order=$model::with('items')->findOrFail($id);
        $products=Product::whereIn('id',$order->items->pluck('product_id'))->get(['id','sku','name'])->keyBy('id');
        return Inertia::render('smartstock/order-show',['kind'=>$kind,'order'=>$order,
            'lines'=>$order->items->map(fn($it)=>['id'=>$it->id,'product'=>$products[$it->product_id]->name??'#'.$it->product_id,
                'sku'=>$products[$it->product_id]->sku??'','quantity'=>$it->quantity,
                'price'=>$it->unit_cost??$it->unit_price,'amount'=>$it->line_total])]);
    }
    public function action(Request $request,string $kind,int $id,string $action)
    {
        $purchase=$this->isPurchase($kind);
        $allowed=$purchase?
            ['submit'=>['purchasing','admin'],'approve'=>['manager','admin'],'reject'=>['manager','admin'],
                'receive'=>['warehouse','admin'],'complete'=>['purchasing','admin'],'cancel'=>['purchasing','admin']]:
            ['confirm'=>['sales','admin'],'fulfill'=>['warehouse','admin'],'cancel'=>['sales','admin']];
        abort_unless(isset($allowed[$action]),404);
        abort_unless($request->user()->hasAnyRole($allowed[$action]),403);
        $data=$request->validate(['reason'=>['nullable','string','max:500']]);
        $this->service->transition($kind,$id,$action,(int)$request->user()->id,$data['reason']??null);
        return back()->with('success','Đã thực hiện: '.$action);
    }
}
