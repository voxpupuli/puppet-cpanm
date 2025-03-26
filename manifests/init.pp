#
# @summary Downloads and installs cpanminus.
#
# @param installer
#   Url to the cpanm installer.
#
# @param manage_dependencies
#   Wether this module should manage the following dependencies
#   - perl
#   - perl-core (rhel7)
#   - make
#   - gcc
#
# @param mirror
#   A CPAN mirror to use to retrieve App::cpanminus. This is passed to
#   `cpanm` as `--from`, meaning that only this mirror will be used.
#
# @param lwpbootstraparg
#   cpanminus bootstrap arguments
#
# @example
#   include cpanm
#
# @example
#   class {'cpanm':
#     mirror =>  'http://mirror.my.org/cpan/',
#   }
#
# @author James McDonald <james@jamesmcdonald.com>
#
class cpanm (
  Cpanm::HTTPUrl $installer = 'https://cpanmin.us',
  Boolean $manage_dependencies = true,
  Optional[Cpanm::HTTPUrl] $mirror = undef,
  Boolean $lwpbootstraparg = false,
) {
  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] < '8' {
    $packages = ['perl', 'make', 'gcc', 'perl-core']
  } else {
    $packages = ['perl', 'make', 'gcc']
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
