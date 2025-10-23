# Use PHP 8.2 with Apache (Symfony 7.x compatible)
FROM php:8.2-apache

# Install PHP extensions and system dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git libzip-dev libpng-dev libonig-dev \
 && docker-php-ext-install pdo_mysql mbstring zip gd \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache rewrite (for frameworks)
RUN a2enmod rewrite

# Set working directory inside the container
WORKDIR /var/www

# Copy all project files into container
COPY . /var/www/

# Copy Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Composer dependencies for the backend
RUN if [ -f /var/www/backend/composer.json ]; then \
      cd /var/www/backend && composer install --no-dev --no-interaction --optimize-autoloader; \
      cp -r /var/www/backend/vendor /var/www/vendor; \
    fi


# Copy the backend/public folder (web root)
RUN rm -rf /var/www/html/* || true
COPY backend/public/ /var/www/html/

# Fix permissions for Apache
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

EXPOSE 80
CMD ["apache2-foreground"]
