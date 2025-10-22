# Root Dockerfile — simple wrapper that builds the backend app
# It uses the same base image and steps as backend/Dockerfile
# (keeps behavior predictable for Render when it expects Dockerfile at repo root)

FROM php:8.1-fpm

RUN apt-get update && apt-get install -y git unzip libzip-dev zip libpng-dev libonig-dev curl \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy backend sources into image and install deps (same as backend/Dockerfile)
COPY backend/ /var/www/html/

RUN cd /var/www/html && composer install --no-interaction --prefer-dist || true

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html || true

EXPOSE 9000
CMD ["php-fpm"]
