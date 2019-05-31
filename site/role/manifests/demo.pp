class role::demo {
  include profile::interfaces
  include profile::zones
  include profile::nat
  include profile::security_policies
  include profile::commit

  Class['profile::interfaces'] -> Class['profile::zones'] -> Class['profile::nat'] -> Class['profile::security_policies']
}