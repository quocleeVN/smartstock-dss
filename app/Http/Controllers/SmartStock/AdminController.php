<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\{User,Role,AuditLog};
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;

class AdminController extends Controller
{
    public function index()
    {
        return Inertia::render('smartstock/users',['users'=>User::with('roles:id,code,name')->orderBy('id')->paginate(20),
            'roles'=>Role::select('id','code','name')->get()]);
    }
    public function save(Request $request,int $id=0)
    {
        $data=$request->validate(['name'=>['required','string','max:150'],'email'=>['required','email','max:190',Rule::unique('users','email')->ignore($id)],
            'password'=>[$id?'nullable':'required','string','min:8'],'status'=>['required',Rule::in(['active','inactive'])],
            'role_id'=>['required','exists:roles,id']]);
        DB::transaction(function()use($id,$data,$request){
            if ($id) {
                $user=User::findOrFail($id);
                if ($user->id===$request->user()->id && ($data['status']==='inactive' || (int)$data['role_id']!==(int)$user->roles()->value('roles.id'))) abort(422,'Không thể tự khóa hoặc thay đổi vai trò quản trị của chính mình.');
                $user->name=$data['name'];$user->email=$data['email'];$user->status=$data['status'];
                if (!empty($data['password'])) $user->password=Hash::make($data['password']);$user->save();
            } else $user=User::create(['name'=>$data['name'],'email'=>$data['email'],'password'=>Hash::make($data['password']),'status'=>$data['status'],'email_verified_at'=>now()]);
            $user->roles()->sync([$data['role_id']]);
            AuditLog::create(['user_id'=>$request->user()->id,'action'=>'user.save','entity_type'=>'User','entity_id'=>$user->id,'ip_address'=>$request->ip()]);
        });
        return back()->with('success','Đã lưu tài khoản nhân viên.');
    }
}
