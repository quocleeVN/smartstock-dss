<?php

namespace App\Services;

use App\Models\Inventory;
use App\Models\Warehouse;
use App\Models\InventoryTransaction;
use App\Models\StockAdjustment;
use App\Models\AuditLog;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/** All quantity mutations originate here. Call only inside a DB transaction. */
class StockService
{
    public function locked(int $productId): Inventory
    {
        $warehouseId = Warehouse::where('code', 'MAIN')->value('id');
        $inventory = Inventory::query()->where('product_id', $productId)->where('warehouse_id', $warehouseId)->lockForUpdate()->first();
        if (! $inventory) throw ValidationException::withMessages(['stock'=>'Chưa có số dư tồn kho cho sản phẩm #'.$productId]);
        return $inventory;
    }

    public function move(Inventory $inventory, int $delta, string $type, string $sourceField, int $sourceId, int $userId, ?string $reason = null): void
    {
        if ($delta === 0) throw ValidationException::withMessages(['quantity'=>'Biến động kho không được bằng 0.']);
        $before=(int) $inventory->qty_on_hand;
        $after=$before+$delta;
        if ($after<0) throw ValidationException::withMessages(['stock'=>'Không đủ tồn kho. Hiện có '.$before.' sản phẩm.']);
        $inventory->update(['qty_on_hand'=>$after]);
        InventoryTransaction::create([
            'inventory_id'=>$inventory->id,'movement_type'=>$type,'quantity_delta'=>$delta,
            'qty_before'=>$before,'qty_after'=>$after,$sourceField=>$sourceId,
            'performed_by'=>$userId,'reason'=>$reason,
        ]);
    }

    public function adjust(int $inventoryId, int $target, string $reason, string $type, int $userId): StockAdjustment
    {
        return DB::transaction(function () use ($inventoryId,$target,$reason,$type,$userId) {
            $inventory=Inventory::query()->lockForUpdate()->findOrFail($inventoryId);
            $before=(int)$inventory->qty_on_hand;
            $delta=$target-$before;
            if ($delta===0) throw ValidationException::withMessages(['quantity'=>'Tồn mới phải khác tồn hiện tại.']);
            if ($type==='opening_balance' && InventoryTransaction::where('inventory_id',$inventory->id)->exists()) {
                throw ValidationException::withMessages(['type'=>'Sản phẩm đã có lịch sử; không được nhập tồn đầu lại.']);
            }
            $adjustment=StockAdjustment::create([
                'code'=>'ADJ-'.strtoupper((string)\Illuminate\Support\Str::ulid()),
                'inventory_id'=>$inventory->id,'adjustment_type'=>$type,'qty_before'=>$before,
                'qty_after'=>$target,'quantity_delta'=>$delta,'reason'=>$reason,'created_by'=>$userId,
            ]);
            $movement=$type==='opening_balance'?'opening_balance':($delta>0?'adjustment_in':'adjustment_out');
            $this->move($inventory,$delta,$movement,'stock_adjustment_id',$adjustment->id,$userId,$reason);
            AuditLog::create(['user_id'=>$userId,'action'=>'inventory.adjust','entity_type'=>'StockAdjustment',
                'entity_id'=>$adjustment->id,'new_values'=>['before'=>$before,'after'=>$target,'reason'=>$reason],
                'ip_address'=>request()->ip()]);
            return $adjustment;
        }, 3);
    }
}
