

class panopuppet::config {


  include apache


  file { $::panopuppet::cfg_sqlite_dir :
    ensure => directory,
    owner  => $::panopuppet::wsgi_permissions_user,
    group  => $::panopuppet::wsgi_permissions_group,
    mode   => '0775',
  } ->

  file { '/etc/panopuppet' :
    ensure => directory,
    mode   => '0755',
  } ->

  file { $::panopuppet::panopuppet_cfg_path :
    content => template('panopuppet/config.yaml.erb'),
  } ->

  exec { 'Pip install requirements':
    command => "${panopuppet::pip3_path} install -r ${panopuppet::wsgi_requirements_file} && touch ${panopuppet::wsgi_requirements_file}.installed",
    creates => "${panopuppet::wsgi_requirements_file}.installed",
    require => [
       Package[$::panopuppet::python3_package],
       Package[$::panopuppet::panopuppet_package],
       File[$::panopuppet::panopuppet_cfg_path],
    ],
  } 

  exec { 'DB Make migrations':
    command => "${::panopuppet::python3_path} ${::panopuppet::wsgi_manage_script_path} makemigrations",
    creates => $::panopuppet::wsgi_sqlitedb_path,
    require => [
       Package[$::panopuppet::python3_package],
       Package[$::panopuppet::panopuppet_package],
       Exec['Pip install requirements'],
    ],
  }
 
  exec { 'DB Migrate':
    command => "${::panopuppet::python3_path} ${::panopuppet::wsgi_manage_script_path} migrate",
    creates => $::panopuppet::wsgi_sqlitedb_path,
    require => Exec['DB Make migrations'],
  }

  exec { 'chown sqlite db':
    command => "chown ${::panopuppet::wsgi_permissions_user} ${::panopuppet::wsgi_sqlitedb_path}",
    unless  => "[ \"$(stat -c %U ${::panopuppet::wsgi_sqlitedb_path})\" == \"${::panopuppet::wsgi_permissions_user}\" ]",
    require => Exec['DB Migrate'],
  }



  apache::vhost { $::panopuppet::service_vhost_fqdn:
    docroot             => $::panopuppet::cfg_static_root,
    port                => $::panopuppet::service_vhost_port,
    wsgi_script_aliases => { '/' => $::panopuppet::wsgi_app_script_path },
    wsgi_daemon_process => $::panopuppet::wsgi_daemon_process_name,

    wsgi_daemon_process_options => {
      threads => $::panopuppet::wsgi_daemon_process_threads,
    },

    aliases => [{
      alias => '/static',
      path  => $::panopuppet::cfg_static_root,
    }],

    directories => [{
      'path'    => $::panopuppet::cfg_static_root,
      'require' => 'all granted',
    }],
  }

}
