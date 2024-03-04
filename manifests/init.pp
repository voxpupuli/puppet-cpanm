# Class: cpanm
# ===========================
#
# Full description of class cpanm here.
#
# Parameters
# ----------
#
# @param installer
# Path/url to the cpanm installer.
# Defaults to https://cpanmin.us
#
# @param manage_dependencies
# Wither this module shuld manage the following dependencies
# - curl
# - purl
# - make
#  - gcc
#
# @param mirror
# A CPAN mirror to use to retrieve App::cpanminus. This is passed to
# `cpanm` as `--from`, meaning that only this mirror will be used.
#
# @param lwpbootstraparg
# cpanminus bootstrap arguments
#
# Examples
# --------
#
# @example
#    include cpanm
#
# @example
#    class {'cpanm':
#      mirror =>  'http://mirror.my.org/cpan/',
#    }
#
# Authors
# -------
#
# James McDonald <james@jamesmcdonald.com>
#
# Copyright
# ---------
#
# Copyright 2016-2017 James McDonald, unless otherwise noted.
#
class cpanm (
  Cpanm::HTTPUrl $installer = 'https://cpanmin.us',
  Boolean $manage_dependencies = true,
  Optional[Cpanm::HTTPUrl] $mirror = undef,
  Boolean $lwpbootstraparg = false,
) {
  if $facts['os']['family'] == 'RedHat' {
    $packages = ['curl', 'perl', 'make', 'gcc', 'perl-core']
  } else {
    $packages = ['curl', 'perl', 'make', 'gcc']
  }

  if $manage_dependencies {
    package { $packages:
      before => Exec['install cpanminus'],
    }
  }

  $from = $mirror ? {
    undef   => '',
    default => "--from ${mirror}",
  }

  if ($lwpbootstraparg) {
    $lwparg = '--no-lwp'
  } else {
    $lwparg = ''
  }

  exec { 'install cpanminus':
    command => "/usr/bin/curl -L ${installer} | /usr/bin/perl - ${from} -n App::cpanminus ${lwparg}",
    unless  => '/usr/bin/test -x /usr/bin/cpanm -o -x /usr/local/bin/cpanm',
  }
}
