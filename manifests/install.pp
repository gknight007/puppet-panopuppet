

class panopuppet::install {

  package { $::panopuppet::python3_package :
    ensure => $::panopuppet::python3_package_ensure,

  } ->

  package { $::panopuppet::python3_modwsgi_package :
    ensure => $::panopuppet::python3_modwsgi_package_ensure,
  } ->
  
  package { $::panopuppet::panopuppet_package :
    ensure => $::panopuppet::python3_modwsgi_package_ensure,
  }

}
