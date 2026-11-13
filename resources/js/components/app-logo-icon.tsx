import type { SVGAttributes } from 'react';

export default function AppLogoIcon(props: SVGAttributes<SVGElement>) {
    return (
        <svg {...props} viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <linearGradient id="ssLogoGrad" x1="4" y1="4" x2="44" y2="44" gradientUnits="userSpaceOnUse">
                    <stop offset="0%" stopColor="#06B6D4" />
                    <stop offset="50%" stopColor="#0D9488" />
                    <stop offset="100%" stopColor="#047857" />
                </linearGradient>
                <linearGradient id="ssCubeTop" x1="12" y1="10" x2="36" y2="24" gradientUnits="userSpaceOnUse">
                    <stop offset="0%" stopColor="#FFFFFF" stopOpacity="0.35" />
                    <stop offset="100%" stopColor="#FFFFFF" stopOpacity="0.1" />
                </linearGradient>
            </defs>

            {/* Khung nền bo tròn công nghệ */}
            <rect width="48" height="48" rx="12" fill="url(#ssLogoGrad)" />

            {/* Mặt trên khối hộp Isometric 3D */}
            <path d="M24 10L36 17L24 24L12 17L24 10Z" fill="url(#ssCubeTop)" stroke="#FFFFFF" strokeWidth="2.2" strokeLinejoin="round" />

            {/* Thân khối hộp kho hàng */}
            <path d="M12 17V31L24 38V24M36 17V31L24 38" stroke="#FFFFFF" strokeWidth="2.2" strokeLinejoin="round" />

            {/* Biểu đồ phân tích hỗ trợ quyết định DSS (Growth Pulse) */}
            <path d="M18 29L22 25L26 28L31 20" stroke="#FDE047" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
            <circle cx="31" cy="20" r="1.6" fill="#FDE047" />
        </svg>
    );
}
