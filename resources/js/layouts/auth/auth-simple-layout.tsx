import { Link } from '@inertiajs/react';
import AppLogoIcon from '@/components/app-logo-icon';
import { home } from '@/routes';
import type { AuthLayoutProps } from '@/types';

export default function AuthSimpleLayout({
    children,
    title,
    description,
}: AuthLayoutProps) {
    return (
        <div className="flex min-h-svh flex-col items-center justify-center gap-6 bg-background p-6 md:p-10">
            <div className="w-full max-w-sm">
                <div className="flex flex-col gap-8">
                    <div className="flex flex-col items-center gap-4">
                        <Link
                            href={home()}
                            className="flex flex-col items-center gap-3 font-medium transition hover:opacity-90"
                        >
                            <div className="flex h-12 w-12 items-center justify-center drop-shadow-md">
                                <AppLogoIcon className="size-12" />
                            </div>

                            <div className="flex flex-col items-center text-center">
                                <span className="text-xl font-bold tracking-tight text-slate-900 dark:text-white">
                                    SmartStock <span className="text-teal-600 dark:text-teal-400">DSS</span>
                                </span>
                                <span className="text-xs text-slate-500 dark:text-slate-400">
                                    Hệ thống Quản lý Bán hàng & Kho thông minh
                                </span>
                            </div>
                        </Link>

                        <div className="space-y-2 text-center">
                            <h1 className="text-xl font-medium">{title}</h1>
                            <p className="text-center text-sm text-muted-foreground">
                                {description}
                            </p>
                        </div>
                    </div>
                    {children}
                </div>
            </div>
        </div>
    );
}
