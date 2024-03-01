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
  String $installer = 'https://cpanmin.us',
  Optional[String] $mirror = undef,
  Boolean $lwpbootstraparg = false,
) {
  if $facts['os']['family'] == 'RedHat' {
    $packages = ['perl', 'make', 'gcc', 'perl-core']
  } else {
    $packages = ['perl', 'make', 'gcc']
  }

  ensure_packages($packages, { 'ensure' => 'present' })

  $from = $mirror ? {
    undef   => '',
    default => "--from ${mirror}",
  }

  if ($lwpbootstraparg) {
    $lwparg = '--no-lwp'
  } else {
    $lwparg = ''
  }

  exec { "/usr/bin/curl -L ${installer} | /usr/bin/perl - ${from} -n App::cpanminus ${lwparg}":
    unless  => '/usr/bin/test -x /usr/bin/cpanm -o -x /usr/local/bin/cpanm',
    require => [Package['perl', 'gcc']],
  }
}
