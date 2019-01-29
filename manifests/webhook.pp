#g10k::webhook
class g10k::webhook() {

  # Ruby Dependencies
  $ruby_deps = ['sinatra', 'webrick', 'json']
  each($ruby_deps) |$dep| {
    if !defined(Package[$dep]) {
      package { $dep:
        ensure   => installed,
        provider => puppet_gem,
        notify   => Service['webhook'],
      }
    }
  }

  File {
    owner  => 'root',
    group  => 'root',
    notify => Service['webhook'],
  }

  # Directories
  file { ['/var/log/webhook', '/var/run/webhook']:
    ensure => directory,
    mode   => '0755',
  }

  # Files
  file {
    '/opt/puppetlabs/g10k/webhook':
      ensure => file,
      source => 'puppet:///modules/g10k/webhook',
      mode   => '0755',
    ;
    '/opt/puppetlabs/g10k/webhook.yaml':
      ensure => file,
      source => 'puppet:///modules/g10k/webhook.yaml',
      mode   => '0644',
    ;
    '/var/log/webhook/access.log':
      ensure => file,
      mode   => '0644',
    ;
  }

  systemd::unit_file { 'webhook.service':
    source => 'puppet:///modules/g10k/webhook.unit',
  }
  ~> service { 'webhook':
    ensure => running,
    enable => true,
  }

}