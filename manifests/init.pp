# Class: minio
# ===========================
#
# Manages a Minio installation on various Linux/BSD operating systems.
#
# Parameters
# ----------
#
# * `package_ensure`
# Decides if the `minio` binary will be installed. Default: 'present'
#
# * `manage_user`
# Should we manage provisioning the user? Default: true
#
# * `manage_group`
# Should we manage provisioning the group? Default: true
#
# * `manage_home`
# Should we manage provisioning the home directory? Default: true
#
# * `owner`
# The user owning minio and its' files. Default: 'minio'
#
# * `group`
# The group owning minio and its' files. Default: 'minio'
#
# * `home`
# Qualified path to the users' home directory. Default: empty
#
# * `base_url`
# Download base URL. Default: Github. Can be used for local mirrors.
#
# * `version`
# Release version to be installed.
#
# * `checksum`
# Checksum for the binary.
#
# * `checksum_type`
# Type of checksum used to verify the binary being installed. Default: 'sha256'
#
# * `configuration_directory`
# Directory holding Minio configuration file. Default: '/etc/minio'
#
# * `installation_directory`
# Target directory to hold the minio installation. Default: '/opt/minio'
#
# * `storage_root`
# Directory where minio will keep all data. Default: '/var/minio'
#
# * `log_directory`
# Log directory for minio. Default: '/var/log/minio'
#
# * `listen_ip`
# IP address on which Minio should listen to requests.
#
# * `listen_port`
# Port on which Minio should listen to requests.
#
# * `configuration`
# Hash style settings for configuring Minio.
#
# * `manage_service`
# Should we manage a service definition for Minio?
#
# * `service_template`
# Path to service template file.
#
# * `service_path`
# Where to create the service definition.
#
# * `service_provider`
# Which service provider do we use?
#
# * `service_mode`
# File mode for the created service definition.
#
# Examples
# --------
#
# @example
#    class { 'minio':
#    }
#
# Authors
# -------
#
# Daniel S. Reichenbach <daniel@kogitoapp.com>
#
# Copyright
# ---------
#
# Copyright 2017 Daniel S. Reichenbach <https://kogitoapp.com>
#
class minio (
  $package_ensure = 'present',

  $manage_user = true,
  $manage_group = true,
  $manage_home = true,
  $owner = 'minio',
  $group = 'minio',
  $home = '/home/minio',

  $base_url = 'https://dl.minio.io/server/minio/release',
  $version = 'RELEASE.2017-09-29T19-16-56Z',
  $checksum = 'b7707b11c64e04be87b4cf723cca5e776b7ed3737c0d6b16b8a3d72c8b183135',
  $checksum_type = 'sha256',
  $configuration_directory = '/etc/minio',
  $installation_directory = '/opt/minio',
  $storage_root = '/var/minio',
  $log_directory = '/var/log/minio',
  $listen_ip = '127.0.0.1',
  $listen_port = 9000,

  $configuration = {
    'version' => '19',
    'credential' => {
      'accessKey' => 'ADMIN',
      'secretKey' => 'PASSWORD',
    },
    'region'     => 'us-east-1',
    'browser'    => 'on',
  },

  $manage_service = true,
  $service_template = 'minio/systemd.erb',
  $service_path = '/lib/systemd/system/minio.service',
  $service_provider = 'systemd',
  $service_mode = '0644',
  ) {

  validate_string($package_ensure)
  
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_bool($manage_home)
  
  validate_string($owner)
  validate_string($group)
  
  # validate_array($home)

  validate_string($base_url)
  validate_string($version)
  validate_string($checksum)
  validate_string($checksum_type)
  validate_string($configuration_directory)
  validate_string($installation_directory)
  validate_string($storage_root)
  validate_string($log_directory)
  validate_string($listen_ip)
  validate_integer($listen_port)
  
  validate_hash($configuration)

  validate_bool($manage_service)
  validate_string($service_template)
  validate_string($service_path)
  validate_string($service_provider)
  validate_string($service_mode)

  class { '::minio::user': }
  class { '::minio::install': }

  class { '::minio::config': }
  class { '::minio::service': }

  anchor { 'minio::begin': }
  anchor { 'minio::end': }

  Anchor['minio::begin']
  -> Class['minio::user']
  -> Class['minio::install']
  -> Class['minio::config']
  ~> Class['minio::service']
}
