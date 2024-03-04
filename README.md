# cpanm

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

If you make improvements or fixes, please feel free to send a PR on Github.
This module exists to solve a specific problem for me, but I'm quite happy to
extend it to support other people's use cases.
