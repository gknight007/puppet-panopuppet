

class panopuppet (
  $python3_package                   = 'python3',
  $python3_package_ensure            = 'latest',
  $python3_modwsgi_package           = 'mod_wsgi3',
  $python3_modwsgi_package_ensure    = 'latest',
  $panopuppet_package                = 'panopuppet',
  $service_vhost_fqdn                = $::fqdn,
  $service_vhost_port                = '80',
  $cfg_auth_method                   = 'basic',
  $cfg_sqlite_dir                    = '/var/www/panopuppet',
  $cfg_cache_timeout                 = '60',
  $cfg_ldap_server                   = '',
  $cfg_ldap_bind_dn                  = '',
  $cfg_ldap_bind_pw                  = '',
  $cfg_ldap_user_search_path         = '',
  $cfg_ldap_group_search_path        = '',
  $cfg_ldap_allow_group              = '',
  $cfg_ldap_deny_group               = '',
  $cfg_ldap_superuser_group          = '',
  $cfg_ldap_staff_group              = [],
  $cfg_enable_permissions            = 'true',
  $cfg_debug                         = 'false',
  $cfg_template_debug                = 'false',
  $cfg_static_root                   = '/usr/share/panopuppet/static',
  $cfg_secret_key                    = 'super_secure_random_key',
  $cfg_source_name                   = 'PuppetDB Production',
  $cfg_puppetdb_url                  = '',
  $cfg_puppetdb_pub_key_path         = '',
  $cfg_puppetdb_priv_key_path        = '',
  $cfg_puppetdb_verify_ssl           = 'false',
  $cfg_master_client_bucket_show     = 'false',
  $cfg_master_client_bucket_host     = '',
  $cfg_master_client_bucket_priv_key = '',
  $cfg_master_client_bucket_pub_key  = '',
  $cfg_master_client_bucket_ca_cert  = '',
  $cfg_master_file_server_show       = 'false',
  $cfg_master_file_server_url        = '',
  $cfg_master_file_server_pub_key    = '',
  $cfg_master_file_server_priv_key   = '',
  $cfg_master_file_server_ca_cert    = '',
  $cfg_puppet_run_interval           = '30',
  $cfg_session_age                   = '2',
  $cfg_allowed_hosts                 = ['127.0.0.1'],
  $cfg_language_code                 = 'en-US',
  $cfg_time_zone                     = 'America/New_York',
  $panopuppet_sqlite_filename        = 'panopuppet.db.sqlite3',
  $wsgi_directory                    = '/usr/share/panopuppet/wsgi',
  $wsgi_script_name                  = 'wsgi.py',
  $wsgi_manage_script_name           = 'manage.py',
  $wsgi_daemon_process_name          = 'panopuppet',
  $wsgi_daemon_process_threads       = '5',
  $wsgi_permissions_user             = 'apache',
  $wsgi_permissions_group            = 'apache',
){

  $wsgi_app_script_path = "${wsgi_directory}/${wsgi_script_name}"
  $wsgi_manage_script_path = "${wsgi_directory}/${wsgi_manage_script_name}"
  $wsgi_sqlitedb_path = "${cfg_sqlite_dir}/${panopuppet_sqlite_filename}"

  class { '::panopuppet::install': } ->
  class { '::panopuppet::config':  }
} 
