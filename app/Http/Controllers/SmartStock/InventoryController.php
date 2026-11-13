<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\{Inventory,InventoryTransaction,InventoryPolicy,Product,StockAdjustment};
use App\Services\StockService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class InventoryController extends Controller
{
    public function index(Request $request)
    {
        return Inertia::render('smartstock/inventory',[ 
            'items'=>DB::table('inventories as i')->join('products as p','p.id','=','i.product_id')
                ->select('i.id','i.product_id','i.qty_on_hand','p.name','p.sku')
                ->orderBy('p.name')->paginate(20),
            'ledger'=>DB::table('inventory_transactions as t')->join('inventories as i','i.id','=','t.inventory_id')
                ->join('products as p','p.id','=','i.product_id')->select('t.*','p.name as product_name','p.sku')->orderByDesc('t.id')->limit(30)->get(),
        ]);
    }
    public function adjust(Request $request,StockService $service)
    {
        abort_unless($request->user()->hasAnyRole(['warehouse','admin']),403);
        $data=$request->validate(['inventory_id'=>['required','exists:inventories,id'],
            'qty_after'=>['required','integer','min:0','max:100000000'],
            'type'=>['required',Rule::in(['opening_balance','manual'])],
            'reason'=>['required','string','min:3','max:500']]);
        $service->adjust((int)$data['inventory_id'],(int)$data['qty_after'],$data['reason'],$data['type'],(int)$request->user()->id);
        return back()->with('success','Điều chỉnh kho đã được ghi sổ.');
    }
    public function policy(Request $request)
    {
        abort_unless($request->user()->hasAnyRole(['manager','admin']),403);
        $data=$request->validate(['inventory_id'=>['required','exists:inventories,id'],
            'lead_time_days'=>['required','integer','min:1','max:365'],
            'safety_stock_qty'=>['required','integer','min:0'],
            'demand_window_days'=>['required','integer','min:7','max:365'],
            'target_cover_days'=>['required','integer','min:1','max:365']]);
        InventoryPolicy::updateOrCreate(['inventory_id'=>$data['inventory_id']],$data+['updated_by'=>$request->user()->id]);
        return back()->with('success','Đã lưu chính sách tồn kho.');
    }
}
