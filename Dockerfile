# Sử dụng PHP 8.3 Apache chính thức
FROM php:8.3-apache

# Cài đặt các thư viện hệ điều hành và extension PHP cần thiết cho Laravel
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

# Cài đặt Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Kích hoạt Apache mod_rewrite
RUN a2enmod rewrite

# Cấu hình DocumentRoot của Apache trỏ vào thư mục /public của Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html

# Copy toàn bộ mã nguồn (đã bao gồm các file frontend đã build sẵn trong public/build)
COPY . .

# Cài đặt các thư viện PHP production
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Phân quyền thư mục storage và bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Cấu hình entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
