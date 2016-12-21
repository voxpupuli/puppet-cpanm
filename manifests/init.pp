# Class: cpanm
# ===========================
#
# Full description of class cpanm here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# * `managepackages`
#  Whether to manage the packages `gcc`, `make` and `perl`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    include cpanm
#
# Authors
# -------
#
# James McDonald <james@jamesmcdonald.com>
#
# Copyright
# ---------
#
# Copyright 2016 James McDonald, unless otherwise noted.
#
class cpanm {
  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease in ['6','7'] {
    $packages = ['perl', 'make', 'gcc', 'perl-core']
  } else {
    $packages = ['perl', 'make', 'gcc']
  }

  package {$packages:
    ensure => present,
  }

  file {'/var/cache/cpanm-install':
    ensure => file,
    source => 'puppet:///modules/cpanm/cpanm',
  }

  exec {'/usr/bin/perl /var/cache/cpanm-install -n App::cpanminus':
    unless  => '/usr/bin/test -x /usr/bin/cpanm -o -x /usr/local/bin/cpanm',
    require => [File['/var/cache/cpanm-install'], Package['perl', 'gcc']],
  }
}
