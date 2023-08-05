# Menggunakan image PHP-FPM (PHP-FastCGI Process Manager) resmi
FROM php:7.4-fpm

# Install dependensi yang dibutuhkan oleh Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev

# Install ekstensi PHP yang dibutuhkan oleh Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql zip

# Menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Menambahkan direktori aplikasi ke dalam kontainer
COPY . /var/www/html

# Menetapkan direktori kerja
WORKDIR /var/www/html

# Menginstal dependensi proyek menggunakan Composer
RUN composer install

# Menetapkan hak akses ke folder storage dan bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Expose port 9000 (default untuk PHP-FPM)
EXPOSE 9000

# Jalankan perintah PHP-FPM
CMD ["php-fpm"]
