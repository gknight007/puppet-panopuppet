

class ::panopuppet::config {


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

  file { '/etc/panopuppet/config.yaml':
    content => template('panopuppet/config.yaml.erb'),
  } ->
 
  exec { 'DB Migrate':
    command => "python3 $::panopuppet::wsgi_manage_script_path migrate",
    creates => $::panopuppet::wsgi_sqlitedb_path,
  }



  apache::vhost { $::panopuppet::service_vhost_fqdn:
   #FIXME: add conig for error and access logging
    port                => $::panopuppet::service_vhost_port,
    wsgi_script_aliases => { '/' => $::panopuppet::wsgi_app_script_path },
    wsgi_daemon_process => $::panopuppet::wsgi_daemon_process_name,

    wsgi_daemon_process_options => {
      threads => $::panpuppet::wsgi_daemon_process_threads,
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
