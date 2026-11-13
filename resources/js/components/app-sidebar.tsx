import {Link,usePage} from '@inertiajs/react';
import {BarChart3,BookUser,Boxes,Building2,ChartNoAxesCombined,ClipboardCheck,ClipboardList,FolderOpen,LayoutDashboard,Package,Receipt,ShoppingCart,Tags,Truck,Users,Warehouse,Bell,ScrollText} from 'lucide-react';
import AppLogo from '@/components/app-logo';
import {NavMain} from '@/components/nav-main';
import {NavUser} from '@/components/nav-user';
import {Sidebar, SidebarContent,SidebarFooter,SidebarHeader,SidebarMenu,SidebarMenuButton,SidebarMenuItem} from '@/components/ui/sidebar';
import type {NavItem} from '@/types';
export function AppSidebar(){
 const roleCodes:string[]=(usePage().props as any)?.auth?.roles||[];
 const permitted=(roles:string[])=>roleCodes.includes('admin')||roles.some(r=>roleCodes.includes(r));
 const items:NavItem[]=[
 {title:'Tổng quan',href:'/dashboard',icon:LayoutDashboard},
 {title:'Thông báo',href:'/notifications',icon:Bell},
 ...(permitted(['sales'])?[{title:'Bán hàng nhanh (POS)',href:'/pos',icon:ShoppingCart},{title:'Đơn bán hàng',href:'/sale-orders',icon:Receipt}]:[]),
 ...(permitted(['purchasing','warehouse','manager'])?[{title:'Đơn nhập hàng',href:'/purchase-orders',icon:Truck}]:[]),
 ...(permitted(['warehouse','manager','sales','purchasing'])?[{title:'Tồn kho / Lịch sử',href:'/inventory',icon:Warehouse}]:[]),
 ...(permitted(['manager','sales','purchasing','warehouse'])?[{title:'Sản phẩm',href:'/manage/products',icon:Package}]:[]),
 ...(permitted(['manager'])?[{title:'Danh mục',href:'/manage/categories',icon:Tags},{title:'Đơn vị tính',href:'/manage/units',icon:Boxes}]:[]),
 ...(permitted(['sales','manager'])?[{title:'Khách hàng',href:'/manage/customers',icon:Users}]:[]),
 ...(permitted(['purchasing','manager'])?[{title:'Nhà cung cấp',href:'/manage/suppliers',icon:Building2}]:[]),
 ...(permitted(['manager','purchasing'])?[{title:'Phân tích và DSS',href:'/analytics',icon:ChartNoAxesCombined}]:[]),
 ...(permitted(['admin'])?[{title:'Nhân sự & phân quyền',href:'/staff',icon:BookUser},{title:'Nhật ký kiểm toán',href:'/audit',icon:ScrollText}]:[]),
 ];
 return <Sidebar collapsible="icon" variant="inset"><SidebarHeader><SidebarMenu><SidebarMenuItem><SidebarMenuButton size="lg" asChild><Link href="/dashboard"><AppLogo/></Link></SidebarMenuButton></SidebarMenuItem></SidebarMenu></SidebarHeader><SidebarContent><NavMain items={items}/></SidebarContent><SidebarFooter><NavUser/></SidebarFooter></Sidebar>;
}
