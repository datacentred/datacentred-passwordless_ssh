#datacentred-passwordless_ssh

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)

## Overview

Sets up passwordless ssh for a given user with optional privilege escalation

## Module Description

Provided an existing user account this module will create the necessary directories, key files and authorize remote logins.  Unfortunately due to the nature of ssh we also need to disable strict host checking for this user at present.

Optionally this module allows the creation of sudo access for the remote user with full control over which accounts and applications can be accessed.

## Usage

To allows simple remote ssh access:

    passwordless_ssh { 'cephdeploy':
      ssh_private_key => '-----BEGIN RSA PRIVATE KEY----- ...',
      ssh_public_key  => 'AAAAB3NzaC1yc2EAAA ...',
    }

To allow remote access with sudo rights:

    passwordless_ssh { 'dhcp_sync_agent':
      ssh_private_key   => '-----BEGIN RSA PRIVATE KEY----- ...',
      ssh_public_key    => 'AAAAB3NzaC1yc2EAAA ...',
      sudo              => 'true',
      sudo_users        => 'root',
      sudo_applications => '/etc/init.d/isc-dhcp-server',
    }
