import { Link, router, usePage } from '@inertiajs/react';
import type { ReactNode } from 'react';
import { useState } from 'react';

export const money = (v: unknown) => new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(Number(v || 0));
export const number = (v: unknown) => new Intl.NumberFormat('vi-VN').format(Number(v || 0));
export const date = (v: unknown) => v ? new Date(String(v)).toLocaleDateString('vi-VN') : '—';
export const cn = (...args: (string | false | undefined)[]) => args.filter(Boolean).join(' ');
export const statusName: Record<string,string> = { draft:'Nháp',pending_approval:'Chờ duyệt',approved:'Đã duyệt',rejected:'Từ chối',received:'Đã nhận',completed:'Hoàn thành',cancelled:'Đã hủy',confirmed:'Đã xác nhận',proposed:'Đề xuất',converted:'Đã chuyển PO',dismissed:'Bỏ qua',open:'Đang mở',resolved:'Đã giải quyết',active:'Hoạt động',inactive:'Ngừng',normal:'Ổn định',low_stock:'Sắp hết',out_of_stock:'Hết hàng' };
export function Status({value}:{value:string}) {
 const colors:Record<string,string>={completed:'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30',active:'bg-emerald-100 text-emerald-700',approved:'bg-emerald-100 text-emerald-700',confirmed:'bg-blue-100 text-blue-700',pending_approval:'bg-amber-100 text-amber-700',low_stock:'bg-amber-100 text-amber-700',out_of_stock:'bg-red-100 text-red-700',cancelled:'bg-red-100 text-red-700',rejected:'bg-red-100 text-red-700'};
 return <span className={cn('inline-flex rounded-full px-2.5 py-1 text-xs font-semibold', colors[value] || 'bg-slate-100 text-slate-700')}>{statusName[value]||value}</span>;
}
export function Button({children,onClick,disabled=false,kind='primary',type='button',className=''}:{children:ReactNode,onClick?:()=>void,disabled?:boolean,kind?:'primary'|'secondary'|'danger',type?:'button'|'submit',className?:string}) {
 return <button type={type} disabled={disabled} onClick={onClick} className={cn('inline-flex cursor-pointer items-center justify-center rounded-lg px-4 py-2.5 text-sm font-semibold transition disabled:cursor-wait disabled:opacity-50',kind==='primary'?'bg-teal-700 text-white hover:bg-teal-800':kind==='danger'?'bg-red-600 text-white hover:bg-red-700':'border border-slate-200 bg-white text-slate-700 hover:bg-slate-50 dark:bg-slate-900 dark:text-white',className)}>{children}</button>;
}
export function Panel({children,title,action}:{children:ReactNode,title?:string,action?:ReactNode}){
 return <section className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm dark:border-slate-800 dark:bg-slate-900"><div className="mb-4 flex flex-wrap items-center justify-between gap-2">{title&&<h2 className="text-base font-semibold text-slate-800 dark:text-slate-100">{title}</h2>}{action}</div>{children}</section>;
}
export function PageTitle({title,subtitle,action}:{title:string,subtitle?:string,action?:ReactNode}){
 return <div className="mb-6 flex flex-wrap items-center justify-between gap-4"><div><h1 className="text-2xl font-bold tracking-tight text-slate-900 dark:text-white">{title}</h1>{subtitle&&<p className="mt-1 text-sm text-slate-500">{subtitle}</p>}</div>{action}</div>;
}
export function Notice(){ const props=usePage().props as any;const success=props?.flash?.success; return success?<div className="mb-5 rounded-lg border border-emerald-200 bg-emerald-50 p-3 text-sm font-medium text-emerald-800">{success}</div>:null; }
export function Field({label,value,onChange,type='text',required=false,options,placeholder,error}:{label:string,value:any,onChange:(v:string)=>void,type?:string,required?:boolean,options?:any[],placeholder?:string,error?:string}){
 const common='mt-1.5 w-full rounded-lg border border-slate-200 bg-white px-3 py-2.5 text-sm text-slate-800 outline-none focus:ring-2 focus:ring-teal-500 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100';
 return <label className="block text-sm font-medium text-slate-700 dark:text-slate-300">{label}{required&&<span className="text-red-600"> *</span>}
 {options?<select value={value??''} onChange={e=>onChange(e.target.value)} className={common}><option value="">Chọn...</option>{options.map((o:any)=><option key={String(o.id)} value={o.id}>{o.name}</option>)}</select>:<input value={value??''} onChange={e=>onChange(e.target.value)} type={type} placeholder={placeholder} required={required} min={type==='number'?0:undefined} step={type==='number'?'any':undefined} className={common}/>}
 {error&&<span className="mt-1 block text-xs text-red-600">{error}</span>}</label>;
}
export function Pagination({data}:{data:any}){if(!data?.links)return null;return <div className="mt-4 flex flex-wrap gap-1">{data.links.map((link:any,i:number)=><button key={i} disabled={!link.url} onClick={()=>link.url&&router.visit(link.url)} className={cn('rounded-md border px-3 py-2 text-xs',link.active?'bg-teal-700 text-white':'border-slate-200 bg-white text-slate-600',!link.url&&'opacity-40')} dangerouslySetInnerHTML={{__html:link.label}}/>)}</div>}
export function Table({head,children}:{head:string[],children:ReactNode}){return <div className="overflow-x-auto"><table className="w-full min-w-[560px] text-left text-sm"><thead className="bg-slate-50 text-xs uppercase tracking-wide text-slate-500 dark:bg-slate-800"><tr>{head.map(x=><th className="px-3 py-3" key={x}>{x}</th>)}</tr></thead><tbody className="divide-y divide-slate-100 dark:divide-slate-800">{children}</tbody></table></div>}
export function Cell({children}:{children:ReactNode}){return <td className="px-3 py-3.5 text-slate-700 dark:text-slate-200">{children}</td>}
export function Empty({text='Chưa có dữ liệu'}:{text?:string}){return <div className="py-12 text-center text-sm text-slate-500">{text}</div>}
export function usePost(){const [busy,setBusy]=useState(false);const [errors,setErrors]=useState<Record<string,string>>({});const send=(url:string,data:any={},method:'post'|'put'='post',done?:()=>void)=>{setBusy(true);setErrors({});router[method](url,data,{preserveScroll:true,onFinish:()=>setBusy(false),onError:(errors:any)=>setErrors(errors),onSuccess:()=>done?.()});};return {busy,errors,send}}
