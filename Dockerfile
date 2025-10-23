# Use official PHP with Apache
FROM php:8.1-apache

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git libzip-dev libpng-dev libonig-dev \
 && docker-php-ext-install pdo_mysql mbstring zip gd \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable rewrite for frameworks
RUN a2enmod rewrite

# Set working directory (inside container)
WORKDIR /var/www

# Copy everything into container
COPY . /var/www/

# If backend has composer.json, install dependencies there
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN if [ -f /var/www/backend/composer.json ]; then \
      cd /var/www/backend && composer install --no-dev --no-interaction --optimize-autoloader || true; \
    fi

# Copy the backend/public folder (your site) to Apache’s webroot
RUN rm -rf /var/www/html/* || true
COPY backend/public/ /var/www/html/

# Set proper permissions for Apache
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

EXPOSE 80
CMD ["apache2-foreground"]
