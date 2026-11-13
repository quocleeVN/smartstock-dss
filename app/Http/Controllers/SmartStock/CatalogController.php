<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\{Category,Unit,Product,Customer,Supplier,Warehouse,Inventory,InventoryPolicy,Role};
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class CatalogController extends Controller
{
    private const SETS = [
        'categories'=>['model'=>Category::class,'title'=>'Danh mục','cols'=>['code','name','status']],
        'units'=>['model'=>Unit::class,'title'=>'Đơn vị tính','cols'=>['code','name']],
        'products'=>['model'=>Product::class,'title'=>'Sản phẩm','cols'=>['sku','name','category_id','unit_id','cost_price','selling_price','status']],
        'customers'=>['model'=>Customer::class,'title'=>'Khách hàng','cols'=>['name','phone','email','address','status']],
        'suppliers'=>['model'=>Supplier::class,'title'=>'Nhà cung cấp','cols'=>['name','phone','email','address','status']],
    ];
    private function spec(string $name): array { abort_unless(isset(self::SETS[$name]),404);return self::SETS[$name]; }
    private function fields(string $entity,int $id=0): array
    {
        $status=['label'=>'Trạng thái','type'=>'select','options'=>[['id'=>'active','name'=>'Hoạt động'],['id'=>'inactive','name'=>'Ngừng sử dụng']]];
        return match($entity){
            'categories'=>['code'=>['label'=>'Mã danh mục','required'=>true], 'name'=>['label'=>'Tên danh mục','required'=>true],'status'=>$status],
            'units'=>['code'=>['label'=>'Mã đơn vị','required'=>true], 'name'=>['label'=>'Đơn vị tính','required'=>true]],
            'products'=>['sku'=>['label'=>'SKU','required'=>true],'name'=>['label'=>'Tên sản phẩm','required'=>true],
                'category_id'=>['label'=>'Danh mục','type'=>'select','options'=>Category::select('id','name')->get()],
                'unit_id'=>['label'=>'Đơn vị','type'=>'select','options'=>Unit::select('id','name')->get()],
                'cost_price'=>['label'=>'Giá nhập tham khảo','type'=>'number'], 'selling_price'=>['label'=>'Giá bán','type'=>'number'],'status'=>$status],
            'customers','suppliers'=>['name'=>['label'=>'Tên','required'=>true],'phone'=>['label'=>'Số điện thoại'],
                'email'=>['label'=>'Email','type'=>'email'],'address'=>['label'=>'Địa chỉ'],'status'=>$status],
            default=>[]
        };
    }
    private function rules(string $entity,int $id=0): array
    {
        $text=['name'=>['required','string','max:180']];$status=['status'=>['required',Rule::in(['active','inactive'])]];
        return match($entity) {
            'categories'=>['code'=>['required','max:50',Rule::unique('categories','code')->ignore($id)],...$text,...$status],
            'units'=>['code'=>['required','max:30',Rule::unique('units','code')->ignore($id)],...$text],
            'products'=>['sku'=>['required','max:80',Rule::unique('products','sku')->ignore($id)],
                ...$text,'category_id'=>['required','exists:categories,id'],'unit_id'=>['required','exists:units,id'],
                'cost_price'=>['required','numeric','min:0'],'selling_price'=>['required','numeric','min:0'],...$status],
            'customers','suppliers'=>[...$text,'phone'=>['nullable','string','max:30'],'email'=>['nullable','email','max:190'],
                'address'=>['nullable','string','max:255'],...$status],
            default=>[],
        };
    }
    public function index(Request $request, string $entity)
    {
        $spec=$this->spec($entity);
        abort_unless($request->user()->hasAnyRole(match($entity){
            'suppliers'=>['purchasing','manager','admin'],
            'customers'=>['sales','manager','admin'],
            default=>['admin','manager','sales','purchasing','warehouse'],
        }),403);
        $model=$spec['model'];$query=$model::query()->latest('id');
        $search=trim((string)$request->query('q',''));
        if ($search!=='') $query->where(function($q)use($entity,$search){
            $q->where('name','like','%'.$search.'%');
            if ($entity==='products') $q->orWhere('sku','like','%'.$search.'%');
            if (in_array($entity,['categories','units'])) $q->orWhere('code','like','%'.$search.'%');
        });
        $columns=$spec['cols'];$fields=$this->fields($entity);
        if($entity==='products' && !$request->user()->hasAnyRole(['manager','admin','purchasing'])) {
            $columns=array_values(array_diff($columns,['cost_price']));unset($fields['cost_price']);
            $query->select(['id','sku','name','category_id','unit_id','selling_price','status','created_at']);
        }
        return Inertia::render('smartstock/catalog',['entity'=>$entity,'title'=>$spec['title'],
            'rows'=>$query->paginate(15)->withQueryString(), 'columns'=>$columns,'q'=>$search,'fields'=>$fields]);
    }
    public function save(Request $request,string $entity,int $id=0)
    {
        $spec=$this->spec($entity);
        $roles = match ($entity) {
            'products','categories','units' => ['admin','manager'],
            'customers' => ['admin','manager','sales'],
            'suppliers' => ['admin','manager','purchasing'],
            default => ['admin'],
        };
        abort_unless($request->user()->hasAnyRole($roles),403);
        $data=$request->validate($this->rules($entity,$id));
        DB::transaction(function()use($spec,$entity,$id,$data){
            $model=$spec['model'];
            $record=$id?$model::findOrFail($id):$model::create($data);
            if ($id) $record->update($data);
            if (!$id && $entity==='products') {
                $warehouse=Warehouse::where('code','MAIN')->firstOrFail();
                $inventory=Inventory::create(['product_id'=>$record->id,'warehouse_id'=>$warehouse->id,'qty_on_hand'=>0]);
                InventoryPolicy::create(['inventory_id'=>$inventory->id,'updated_by'=>auth()->id(),'lead_time_days'=>5,
                    'safety_stock_qty'=>10,'demand_window_days'=>30,'target_cover_days'=>14]);
            }
        });
        return redirect('/manage/'.$entity)->with('success','Đã lưu dữ liệu.');
    }
}
