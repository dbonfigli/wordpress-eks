{{- define "wordpress.wpconfig" -}}
<?php

{{ if .Values.ingress.https.enabled }}
$_SERVER['HTTPS']='on';
{{ end }}

define( 'WP_SITEURL', '{{ .Values.wordpress.siteurl }}' );
define( 'WP_HOME', '{{ .Values.wordpress.wphome }}' );
define( 'DB_NAME', '{{ .Values.database.name }}' );
define( 'DB_USER', '{{ .Values.database.username }}' );
define( 'DB_PASSWORD', '{{ .Values.database.password }}' );
define( 'DB_HOST', '{{ .Values.database.host }}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define( 'AUTH_KEY',         '{{ .Values.wordpress.salt }}' );
define( 'SECURE_AUTH_KEY',  '{{ .Values.wordpress.salt }}' );
define( 'LOGGED_IN_KEY',    '{{ .Values.wordpress.salt }}' );
define( 'NONCE_KEY',        '{{ .Values.wordpress.salt }}' );
define( 'AUTH_SALT',        '{{ .Values.wordpress.salt }}' );
define( 'SECURE_AUTH_SALT', '{{ .Values.wordpress.salt }}' );
define( 'LOGGED_IN_SALT',   '{{ .Values.wordpress.salt }}' );
define( 'NONCE_SALT',       '{{ .Values.wordpress.salt }}' );
$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';

{{ end }}