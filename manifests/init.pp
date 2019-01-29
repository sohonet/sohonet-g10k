# @summary Manages installing and configuring g10k
#
# @param source_name
#   The primary source name.
#
# @param source_remote
#   The source git remote url.
#
# @param source_basedir
#   The base directory where environments are deployed
#   Default: '/etc/puppetlabs/code/environments'
#
# @param version
#   The version of g10k to install.
#   Default: '0.5.7'
#
# @param user
#   The user to execute the g10k command.
#   Default: 'root'
#
# @param cache_dir
#   The path to the cache directory.
#   Default: '/var/cache/g10k'
#
# @param maxworker
#   The number of Goroutines allowed to run in parallel for Git and Forge
#   module resolving
#
# @param maxextractworker
#   The number of Goroutines allowed to run in parallel for local Git
#   and Forge module extracting processes (git clone, untar and gunzip)
#
# @param is_quiet
#   If true, prints no output.
#
# @param use_cache_fallback
#   If g10k is unable to connect to remote source, the local cache is used.
#
# @param additional_settings
#   A hash of additional g10k.yaml settings that can be configured for a source.
#
# @param proxy_server
#   Web proxy for downloading g10k.
#
# @param postrun
#   Array of strings to be set as the postrun command.
#
class g10k(
  String           $source_name,
  String           $source_remote,
  String           $source_basedir      = '/etc/puppetlabs/code/environments',
  String           $version             = '0.5.7',
  String           $user                = 'root',
  String           $cache_dir           = '/var/cache/g10k',
  Integer          $maxworker           = 50,
  Integer          $maxextractworker    = 20,
  Boolean          $is_quiet            = false,
  Boolean          $use_cache_fallback  = false,
  Optional[Hash]   $additional_settings = undef,
  Array[String]    $postrun             = []
){

  $g10k_file = "g10k-${version}-linux-amd64.zip"
  $g10k_url  = "https://github.com/xorpaul/g10k/releases/download/v${version}/g10k-linux-amd64.zip"

  File {
    owner => $user,
  }

  # Dependencies
  ensure_packages(['unzip'],
    { 'ensure' => 'present' }
  )

  # Directories
  file { ['/etc/puppetlabs/g10k', '/opt/puppetlabs/g10k', $cache_dir]:
    ensure => directory,
    mode   => '0775',
  }

  # Install
  -> archive { "/tmp/g10k/${g10k_file}":
    source       => $g10k_url,
    extract      => true,
    extract_path => '/opt/puppetlabs/g10k/',
    cleanup      => true,
  }

  # Set permissions on g10k binary
  -> file { "/opt/puppetlabs/g10k/${g10k_file}":
    ensure => file,
    mode   => '0755',
  }

  # Configuration
  file { '/etc/puppetlabs/g10k/g10k.yaml':
    ensure  => file,
    content => epp('g10k/g10k.yaml.epp',{
      cache_dir           => $cache_dir,
      source_name         => $source_name,
      source_remote       => $source_remote,
      source_basedir      => $source_basedir,
      use_cache_fallback  => $use_cache_fallback,
      additional_settings => $additional_settings,
      postrun             => $postrun,
    }),
  }

}
