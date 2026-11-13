<?php

namespace Tests\Feature;

use App\Models\{Customer,Inventory,InventoryTransaction,Product,PurchaseOrder,SalesOrder,User,Supplier};
use App\Services\OrderService;
use Database\Seeders\DatabaseSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Validation\ValidationException;
use Tests\TestCase;

class SmartStockWorkflowTest extends TestCase
{
    use RefreshDatabase;

    private function seedBase(): void { $this->seed(DatabaseSeeder::class); }
    private function actor(string $role): User { return User::where('email',$role.'@smartstock.test')->firstOrFail(); }

    public function test_sale_is_recorded_once_only_when_warehouse_fulfills(): void
    {
        $this->seedBase();
        $product=Product::firstOrFail();$before=(int)Inventory::where('product_id',$product->id)->value('qty_on_hand');
        $id=app(OrderService::class)->create('sale',Customer::firstOrFail()->id,[['product_id'=>$product->id,'quantity'=>2]],$this->actor('sales')->id);
        $this->assertSame('draft',SalesOrder::findOrFail($id)->status);
        app(OrderService::class)->transition('sale',$id,'confirm',$this->actor('sales')->id);
        $this->assertSame($before,(int)Inventory::where('product_id',$product->id)->value('qty_on_hand'));
        app(OrderService::class)->transition('sale',$id,'fulfill',$this->actor('warehouse')->id);
        $this->assertSame('completed',SalesOrder::findOrFail($id)->status);
        $this->assertSame($before-2,(int)Inventory::where('product_id',$product->id)->value('qty_on_hand'));
        $this->assertSame(1,InventoryTransaction::whereNotNull('sales_order_item_id')->count());
    }

    public function test_po_cannot_be_self_approved_and_cannot_be_received_twice(): void
    {
        $this->seedBase();
        $product=Product::firstOrFail();$before=(int)Inventory::where('product_id',$product->id)->value('qty_on_hand');
        $buyer=$this->actor('purchasing');$manager=$this->actor('manager');$warehouse=$this->actor('warehouse');
        $svc=app(OrderService::class);
        $id=$svc->create('purchase',Supplier::firstOrFail()->id,[['product_id'=>$product->id,'quantity'=>5]],$buyer->id);
        $svc->transition('purchase',$id,'submit',$buyer->id);
        try{$svc->transition('purchase',$id,'approve',$buyer->id);$this->fail('Self-approval should fail');}
        catch(ValidationException $e){$this->assertTrue(true);}
        $svc->transition('purchase',$id,'approve',$manager->id);
        $this->assertSame($before,(int)Inventory::where('product_id',$product->id)->value('qty_on_hand'));
        $svc->transition('purchase',$id,'receive',$warehouse->id);
        $this->assertSame($before+5,(int)Inventory::where('product_id',$product->id)->value('qty_on_hand'));
        try{$svc->transition('purchase',$id,'receive',$warehouse->id);$this->fail('Repeated receipt should fail');}
        catch(ValidationException $e){$this->assertSame($before+5,(int)Inventory::where('product_id',$product->id)->value('qty_on_hand'));}
    }

    public function test_two_confirmed_sales_competing_for_inventory_cannot_oversell(): void
    {
        $this->seedBase();
        $product = Product::firstOrFail();
        $quantity = (int) Inventory::where('product_id', $product->id)->value('qty_on_hand');
        $sales = $this->actor('sales');
        $worker = $this->actor('warehouse');
        $service = app(OrderService::class);
        $requested = (int) ceil($quantity * 0.75);
        $ids = [];
        for ($i = 0; $i < 2; $i++) {
            $id = $service->create('sale', Customer::firstOrFail()->id, [
                ['product_id' => $product->id, 'quantity' => $requested],
            ], $sales->id, true);
            $ids[] = $id;
        }
        $service->transition('sale', $ids[0], 'fulfill', $worker->id);
        try {
            $service->transition('sale', $ids[1], 'fulfill', $worker->id);
            $this->fail('Second order must not ship into a negative balance');
        } catch (ValidationException $e) {
            $this->assertSame('confirmed', SalesOrder::findOrFail($ids[1])->status);
            $this->assertSame($quantity - $requested, (int) Inventory::where('product_id', $product->id)->value('qty_on_hand'));
            $this->assertSame(1, InventoryTransaction::whereNotNull('sales_order_item_id')->count());
        }
    }

    public function test_generated_line_total_is_computed_from_snapshot_price(): void
    {
        $this->seedBase();
        $product = Product::firstOrFail();
        $orderId = app(OrderService::class)->create('sale', Customer::firstOrFail()->id, [
            ['product_id' => $product->id, 'quantity' => 2],
        ], $this->actor('sales')->id);
        $line = SalesOrder::findOrFail($orderId)->items()->firstOrFail();
        $expected = (float) $product->selling_price * 2;
        $this->assertEqualsWithDelta($expected, (float) $line->line_total, 0.01);
        $this->assertEqualsWithDelta($expected, (float) SalesOrder::findOrFail($orderId)->total_amount, 0.01);
    }

    public function test_unauthorized_sales_user_cannot_approve_purchase_or_adjust_stock(): void
    {
        $this->seedBase();$sales=$this->actor('sales');
        $this->actingAs($sales)->post('/purchase-orders/999/approve')->assertForbidden();
        $this->actingAs($sales)->post('/inventory/adjust',['inventory_id'=>1,'qty_after'=>25,'type'=>'manual','reason'=>'Test'])->assertForbidden();
    }
}
