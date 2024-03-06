# cpanm

[![CI](https://github.com/voxpupuli/puppet-cpanm/actions/workflows/ci.yml/badge.svg)](https://github.com/voxpupuli/puppet-cpanm/actions/workflows/ci.yml)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-cpanm/badge.svg?branch=main)](https://coveralls.io/github/voxpupuli/puppet-cpanm)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/cpanm.svg)](https://forge.puppetlabs.com/puppet/cpanm)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/cpanm.svg)](https://forge.puppetlabs.com/puppet/cpanm)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/cpanm.svg)](https://forge.puppetlabs.com/puppet/cpanm)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/cpanm.svg)](https://forge.puppetlabs.com/puppet/cpanm)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-openssl.svg)](LICENSE)
[![Donated by](https://img.shields.io/badge/donated%20by-James%20McDonald-fb7047.svg)](#transfer-notice)

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with cpanm](#setup)
    * [What cpanm affects](#what-cpanm-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with cpanm](#beginning-with-cpanm)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
    * [Known Issues](#known-issues)
1. [Development - Guide for contributing to the module](#development)

## Description

The cpanm module manages CPAN packages using the cpanminus package. It exists
to provide a simple way to install CPAN modules with the option to not run test
suites.  The intent is that it should work with Debianish and Redhatty
distributions.

The module provides a class `cpanm` which will install Perl components, gcc,
make and cpanminus itself. It also provides a resource type `cpanm` which you
can use to manage modules in more or less the same way as `package` works.

## Setup

### What cpanm affects

This module will install the following packages unless manage_dependencies is set to false:
* perl
* gcc
* make
* perl-core on RHEL7

It will also install `cpanm` itself in a standard directory, generally
`/usr/bin` or `/usr/local/bin`.

### Setup Requirements

This module uses curl to download the cpanminus installer.

### Beginning with cpanm

```
include cpanm

cpanm {'CGI':
  ensure => latest,
}
```

## Usage

Both the `cpanm` class and resource support a `mirror` parameter to control
which CPAN archive packages are fetched from. The `cpanm` resource supports
additional parameters, `test` and `force`, to enable CPAN tests and force CPAN
installation respectively.

## Limitations

The listing of installed CPAN modules is based on `perldoc perllocal`. This
generally works well, but doesn't get updated when you remove a CPAN module.

## Development

This module is maintained by [Vox Pupuli](https://voxpupuli.org/). Vox Pupuli
welcomes new contributions to this module, especially those that include
documentation and rspec tests. We are happy to provide guidance if necessary.

Please see [CONTRIBUTING](.github/CONTRIBUTING.md) for more details.

Please log tickets and issues on github.

## Transfer Notice

This module was originally authored by James McDonald <james@jamesmcdonald.com>.
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead.

Previously: https://github.com/jamesmcdonald/puppet-cpanm
