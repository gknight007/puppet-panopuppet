

class panopuppet (
  $python3_package                   = 'python34',
  $python3_package_ensure            = 'latest',
  $python3_modwsgi_package           = 'mod_wsgi',
  $python3_modwsgi_package_ensure    = 'latest',
  $panopuppet_package                = 'panopuppet',
  $sqlite_dir                        = '/var/www/panopuppet',
  $wsgi_permissions_user             = 'apache',
  $wsgi_permissions_group            = 'apache',
  $wsgi_requirements_file            = '/etc/panopuppet/requirements.txt',
  $wsgi_script_name                  = 'wsgi.py',
  $wsgi_manage_script_name           = 'manage.py',
  $wsgi_directory                    = '/usr/share/panopuppet/wsgi',
  $wsgi_daemon_process_name          = 'panopuppet',
  $wsgi_daemon_process_threads       = '5',
  $panopuppet_cfg_path               = '/etc/panopuppet/config.yaml',

  $python3_path                      = '/opt/python3/bin/python3',
  $pip3_path                         = '/opt/python3/bin/pip3',
  $service_vhost_fqdn                = $::fqdn,
  $service_vhost_port                = '80',
  $cfg_static_root                   = '/usr/share/panopuppet/static',
  $panopuppet_sqlite_filename        = 'panopuppet.db.sqlite3',

  $allowed_hosts                     = ['*'],
  $template_debug                    = 'false',
  $secret_key                        = 'super_secure_random_key',
  $debug                             = 'false',
  $template_debug                    = 'false',
  $django_lang_code                  = 'en-US',
  $django_time_zone                  = 'America/New_York',

){

  $wsgi_app_script_path = "${wsgi_directory}/${wsgi_script_name}"
  $wsgi_manage_script_path = "${wsgi_directory}/${wsgi_manage_script_name}"
  $wsgi_sqlitedb_path = "${cfg_sqlite_dir}/${panopuppet_sqlite_filename}"

  class { '::panopuppet::install': } ->
  class { '::panopuppet::config':  }
} 
