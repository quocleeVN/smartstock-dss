<?php

namespace Database\Seeders;

use App\Models\{User,Customer,Product,SalesOrder};
use App\Services\OrderService;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;

/** Optional synthetic history, for thesis demonstrations ONLY. */
class SmartStockDemoSeeder extends Seeder
{
    public function run(): void
    {
        if (! app()->environment(['local','testing'])) {
            throw new \RuntimeException('Synthetic sales history may only be seeded locally.');
        }
        $sales=User::where('email','sales@smartstock.test')->firstOrFail();
        $warehouse=User::where('email','warehouse@smartstock.test')->firstOrFail();
        $customer=Customer::firstOrFail();$products=Product::orderBy('id')->get();
        if ($products->count()<3) return;
        $service=app(OrderService::class);
        for($i=0;$i<18;$i++) {
            $code='DEMO-SO-'.str_pad((string)($i+1),3,'0',STR_PAD_LEFT);
            if(SalesOrder::where('code',$code)->exists()) continue;
            $product=$products[$i%$products->count()];
            $second=$products[($i+3)%$products->count()];
            $lines=[['product_id'=>$product->id,'quantity'=>($i%3)+1]];
            if($product->id!==$second->id) $lines[]=['product_id'=>$second->id,'quantity'=>1];
            $id=$service->create('sale',$customer->id,$lines,$sales->id);
            $service->transition('sale',$id,'confirm',$sales->id);
            $service->transition('sale',$id,'fulfill',$warehouse->id);
            // Retroactive timestamps document synthetic history, never presented as real sales.
            $date=Carbon::now()->startOfWeek()->subWeeks(18-$i)->addDays(2)->setTime(10,0);
            SalesOrder::whereKey($id)->update(['code'=>$code,'created_at'=>$date,'confirmed_at'=>$date,'completed_at'=>$date]);
        }
    }
}
