#!/bin/bash
set -e

# Đổi cổng Apache theo biến $PORT của Render
if [ -n "$PORT" ]; then
    sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
fi

# Đảm bảo các thư mục storage tồn tại đầy đủ
mkdir -p /var/www/html/storage/framework/sessions
mkdir -p /var/www/html/storage/framework/views
mkdir -p /var/www/html/storage/framework/cache/data
mkdir -p /var/www/html/storage/logs
mkdir -p /var/www/html/bootstrap/cache

# Tạo storage link nếu chưa có
php artisan storage:link --force || true

# Tối ưu hóa Laravel cache
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Chạy migration nếu database sẵn sàng
php artisan migrate --force || true

# Phân quyền lại toàn bộ storage và bootstrap/cache cho Apache www-data
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Khởi động Apache
exec apache2-foreground
