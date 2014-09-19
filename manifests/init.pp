# == Define: passwordless_ssh
#
# Common pattern to define passwordless ssh access for a
# particular user.  Additionally allows sudo access for
# said user if required
#
# === Parameters
#
# [*title*]
#   User account to generate the passwordless access for [Mandatory]
#
# [*ssh_private_key*]
#   Full private key file contents [Mandatory]
#
# [*ssh_public_key*]
#   Public key portion of the public key file [Mandatory]
#
# [*sudo*]
#   Whether the remote client needs sudo rights [Optional]
#
# [*sudo_host*]
#   Hosts or IPs allowed sudo access [Optional]
#
# [*sudo_users*]
#   User accounts that sudo allows to be accessed [Optional]
#
# [*sudo_applications*]
#   Applications sudo is allowed to execute [Optional]
#
define passwordless_ssh (
  $ssh_private_key,
  $ssh_public_key,
  $sudo = false,
  $sudo_host = 'ALL',
  $sudo_users = 'ALL',
  $sudo_applications = 'ALL',
) {

  File {
    owner => $title,
    group => $title,
  }

  file { "/home/${title}/.ssh":
    ensure => directory,
    mode   => '0755',
  } ->

  file { "/home/${title}/.ssh/id_rsa":
    ensure  => file,
    mode    => '0400',
    content => $ssh_private_key,
  } ->

  file { "/home/${title}/.ssh/id_rsa.pub":
    ensure  => file,
    mode    => '0644',
    content => inline_template("ssh-rsa ${ssh_public_key} ${title}@${::fqdn}"),
  } ->

  file { "/home/${title}/.ssh/config":
    ensure  => file,
    mode    => '0644',
    content => template('passwordless_ssh/config.erb'),
  } ->

  ssh_authorized_key { "${title}@${::fqdn}":
    user    => $title,
    type    => 'ssh-rsa',
    key     => $ssh_public_key,
  }

  if $sudo {

    file { "/etc/sudoers.d/${title}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => inline_template("${title}  ${sudo_host}=(${sudo_users}) NOPASSWD:${sudo_applications}"),
    }

  }

}
