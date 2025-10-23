FROM php:8.1-apache

# Install common extensions (edit as needed)
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libzip-dev zip unzip git \
 && docker-php-ext-install pdo_mysql mbstring exif bcmath gd zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
COPY . /var/www/html

# If you use composer (optional)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN if [ -f composer.json ]; then composer install --no-dev --no-interaction --optimize-autoloader || true; fi

RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
