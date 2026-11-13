#!/bin/bash
set -e

# Đổi cổng Apache nếu nền tảng Cloud cung cấp biến môi trường $PORT (Render, Koyeb, Railway)
if [ -n "$PORT" ]; then
    sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
fi

# Tối ưu hóa Laravel cache
php artisan storage:link --force || true
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Khởi động Apache
exec apache2-foreground
