<?php

namespace App\Http\Controllers\SmartStock;

use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $user=$request->user();
        return Inertia::render('smartstock/notifications',[
            'items'=>DB::table('notifications')->where('notifiable_type',get_class($user))
                ->where('notifiable_id',$user->id)->orderByDesc('created_at')->paginate(20),
        ]);
    }
    public function read(Request $request,string $id)
    {
        DB::table('notifications')->where('id',$id)->where('notifiable_type',get_class($request->user()))
            ->where('notifiable_id',$request->user()->id)->update(['read_at'=>now()]);
        return back()->with('success','Đã đánh dấu thông báo được đọc.');
    }
    public function audit()
    {
        return Inertia::render('smartstock/audit',['items'=>AuditLog::orderByDesc('id')->paginate(30)]);
    }
}
