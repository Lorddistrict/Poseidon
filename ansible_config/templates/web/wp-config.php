<?php
define('DB_NAME', '{{ wordpress_name }}' );
define('DB_USER', '{{ wordpress_user }}');
define('DB_PASSWORD', '{{ wordpress_password }}');
define('DB_HOST', '{{ wordpress_host }}');

if ( ! defined( 'ABSPATH' ) )
    define( 'ABSPATH', dirname( __FILE__ ) . '/' );

require_once( ABSPATH . 'wp-settings.php' );