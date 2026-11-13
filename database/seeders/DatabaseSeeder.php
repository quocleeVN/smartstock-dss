<?php

namespace Database\Seeders;

use App\Models\{User,Role,Permission,Category,Unit,Product,Customer,Supplier,Warehouse,Inventory,InventoryPolicy,PurchaseOrder,SalesOrder};
use App\Services\{StockService,OrderService};
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Carbon;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        if (! app()->environment(['local','testing'])) {
            throw new \RuntimeException('Demo seed data is allowed only in local/testing environments.');
        }
        DB::transaction(function() {
            $roles=['admin'=>'Quản trị viên','manager'=>'Quản lý','sales'=>'Nhân viên bán hàng',
                'purchasing'=>'Nhân viên mua hàng','warehouse'=>'Nhân viên kho'];
            $r=[];foreach($roles as $code=>$name)$r[$code]=Role::firstOrCreate(['code'=>$code],['name'=>$name]);
            $perms=['catalog.manage','purchase.create','purchase.approve','purchase.receive','sale.create','sale.fulfill','inventory.adjust','dss.view','staff.manage'];
            foreach ($perms as $perm) Permission::firstOrCreate(['code'=>$perm],['description'=>$perm]);
            $rolePerms=['admin'=>$perms,'manager'=>['catalog.manage','purchase.approve','dss.view'],
                'sales'=>['sale.create'],'purchasing'=>['purchase.create'],'warehouse'=>['purchase.receive','sale.fulfill','inventory.adjust']];
            foreach($rolePerms as $role=>$keys)$r[$role]->permissions()->sync(Permission::whereIn('code',$keys)->pluck('id'));
            foreach($roles as $role=>$name){
                $user=User::firstOrCreate(['email'=>$role.'@smartstock.test'],[
                    'name'=>$name,'password'=>Hash::make('SmartStock@2026'),'status'=>'active','email_verified_at'=>now()]);
                $user->roles()->sync([$r[$role]->id]);
            }
            Warehouse::firstOrCreate(['code'=>'MAIN'],['name'=>'Kho chính','status'=>'active']);
            foreach(['LAPTOP'=>'Laptop','PHONE'=>'Điện thoại','ACC'=>'Phụ kiện','MONITOR'=>'Màn hình'] as $code=>$name)
                Category::firstOrCreate(['code'=>$code],['name'=>$name,'status'=>'active']);
            $unit=Unit::firstOrCreate(['code'=>'PCS'],['name'=>'Cái']);
            $items=[
                ['LAP-001','Laptop Dell Inspiron 15','LAPTOP',12500000,15900000,36],
                ['LAP-002','Laptop ASUS Vivobook','LAPTOP',14500000,17900000,22],
                ['LAP-003','MacBook Air M2','LAPTOP',19000000,24490000,14],
                ['PHO-001','Samsung Galaxy A55','PHONE',6900000,8990000,40],
                ['PHO-002','iPhone 15','PHONE',14900000,18990000,18],
                ['ACC-001','Chuột Logitech M650','ACC',310000,450000,76],
                ['ACC-002','Bàn phím Akko 5075','ACC',980000,1290000,44],
                ['ACC-003','Tai nghe Sony WH-CH520','ACC',990000,1490000,39],
                ['MON-001','Màn hình LG 24 inch','MONITOR',2300000,3190000,26],
                ['MON-002','Màn hình Dell 27 inch','MONITOR',4100000,5390000,12],
            ];
            foreach($items as [$sku,$name,$category,$cost,$price,$qty]){
                $product=Product::firstOrCreate(['sku'=>$sku],[
                    'name'=>$name,'category_id'=>Category::where('code',$category)->value('id'),
                    'unit_id'=>$unit->id,'cost_price'=>$cost,'selling_price'=>$price,'status'=>'active']);
                $inventory=Inventory::firstOrCreate(['product_id'=>$product->id,'warehouse_id'=>Warehouse::where('code','MAIN')->value('id')],['qty_on_hand'=>0]);
                InventoryPolicy::firstOrCreate(['inventory_id'=>$inventory->id],[
                    'lead_time_days'=>5,'safety_stock_qty'=>10,'demand_window_days'=>30,'target_cover_days'=>14,
                    'updated_by'=>User::where('email','manager@smartstock.test')->value('id')]);
                if (!\App\Models\InventoryTransaction::where('inventory_id',$inventory->id)->exists())
                    app(StockService::class)->adjust($inventory->id,$qty,'Tồn đầu minh họa','opening_balance',
                        User::where('email','warehouse@smartstock.test')->value('id'));
            }
            foreach (['Nguyễn Văn An','Trần Thị Bình','Lê Văn Cường','Phạm Minh Đức','Khách lẻ tại quầy'] as $name)
                Customer::firstOrCreate(['name'=>$name],['status'=>'active']);
            foreach (['Công ty Thiết bị A','Nhà phân phối Công nghệ B','Kho hàng Điện tử C'] as $name)
                Supplier::firstOrCreate(['name'=>$name],['status'=>'active']);
        });
        // Demo transaction history is optional: stock opening balances are real ledger entries.
        // No fabricated completed orders: create them through the application so state changes are auditable.
    }
}
