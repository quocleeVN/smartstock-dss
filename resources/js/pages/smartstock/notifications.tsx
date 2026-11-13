import {Head,router} from '@inertiajs/react';
import {Button,Cell,date,Empty,Notice,PageTitle,Pagination,Panel,Table} from './ui';
export default function Notifications({items}:{items:any}){
 return <><Head title="Thông báo"/><PageTitle title="Thông báo hệ thống" subtitle="Cảnh báo tồn kho được gửi cho người quản lý"/><Notice/><Panel><Table head={['Thời gian','Nội dung','Trạng thái','Thao tác']}>{items.data.map((x:any)=>{let d:any={};try{d=typeof x.data==='string'?JSON.parse(x.data):x.data}catch{};return <tr key={x.id}><Cell>{date(x.created_at)}</Cell><Cell><div className="font-semibold">{d.title||'Thông báo'}</div><div className="text-sm text-slate-500">{d.message}</div></Cell><Cell>{x.read_at?'Đã đọc':'Chưa đọc'}</Cell><Cell>{!x.read_at&&<Button kind="secondary" onClick={()=>router.post('/notifications/'+x.id+'/read')}>Đánh dấu đã đọc</Button>}</Cell></tr>})}</Table>{!items.data.length&&<Empty text="Chưa có thông báo"/>}<Pagination data={items}/></Panel></>;
}
