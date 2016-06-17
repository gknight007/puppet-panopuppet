
class panopuppet (
  $wsgi_dir = '/var/www/panopuppet',
  $static_root = '/var/www/panopuppet/staticfiles',
  $secret_key = 'password123',
  $allowed_hosts = ['*'],
  $puppetdb_url = '',
  $vhost_port = 80,
  $wsgi_thread_count = 5,
){

  $cfg_file = "${wsgi_dir}/config.yaml"

  include apache
  
  package { [[
    'httpd-devel',
    'python34',
    'python34-devel',
    'libyaml-devel',
    'openldap-devel',
    'cyrus-sasl-devel',
    'gcc',
    'make',
    'panopuppet',
    'python3-mod_wsgi',
    'python3-pip',
    ]]:
  
    ensure => latest,
  }
  
  
  apache::vhost { 'panopuppet':
      docroot             => $static_root,
      port                => $vhost_port,
      wsgi_script_aliases => { '/' => "${wsgi_dir}/wsgi.py" },
      wsgi_daemon_process => "panopuppet",
  
      wsgi_daemon_process_options => {
        threads => $wsgi_thread_count,
      },
  
      aliases => [{
        alias => '/static',
        path  => $static_root,
      }],
  
      directories => [{
        'path'    => $static_root,
        'require' => 'all granted',
      }],
  }


  file { $wsgi_dir :
    ensure => directory,
  } ->
  
  file { "${wsgi_dir}/manage.py" :
    content => template("panopuppet/manage.py.erb"),
    mode    => '0755',
  } ->
  
  file { "${wsgi_dir}/wsgi.py" :
    content => template("panopuppet/wsgi.py.erb"),
    mode    => '0755',
  } ->
  
  file { "${wsgi_dir}/config.yaml" :
    content => template("panopuppet/config.yaml.erb"),
    mode    => '0600',
  } ->
  
  exec { "python3 ${wsgi_dir}/manage.py collectstatic":
    creates => "${wsgi_dir}/staticfiles",
  } ->
  
  exec { "python3 ${wsgi_dir}/manage.py makemigrations":
    creates => "${wsgi_dir}/panopuppet.db.sqlite3",
  } ->
  
  exec { "python3 ${wsgi_dir}/manage.py syncdb":
    creates => "${wsgi_dir}/panopuppet.db.sqlite3",
  } ->
  
  exec { "chown -R apache:apache ${wsgi_dir}": 
    notify => Service['httpd'],
  }
  



}


