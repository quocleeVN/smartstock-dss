# ---------------------------------------------
# Stage 1: Build Frontend Assets bằng Node.js
# ---------------------------------------------
FROM node:22-alpine AS frontend
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---------------------------------------------
# Stage 2: Môi trường chạy PHP 8.3 + Apache
# ---------------------------------------------
FROM php:8.3-apache

# Cài đặt các thư viện hệ thống và extension PHP cần thiết cho Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Bật Apache mod_rewrite
RUN a2enmod rewrite

# Cấu hình DocumentRoot trỏ vào thư mục /public của Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

# Copy toàn bộ mã nguồn
COPY . .

# Copy assets đã build từ Stage 1
COPY --from=frontend /app/public/build /var/www/html/public/build

# Cài đặt PHP dependencies (tối ưu production)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Phân quyền thư mục storage và cache cho Apache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy và cấp quyền thực thi cho entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Cổng mặc định
EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
