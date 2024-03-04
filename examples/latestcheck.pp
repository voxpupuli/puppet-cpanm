include cpanm

$deps = [
  'openssl', 'openssl-devel',
]

package { $deps:
  ensure => present,
}

$modules = [
  'Array::Utils',
  'Attribute::Handlers',
  'CGI',
  'Carp',
  'Config::Properties',
  'Cwd',
  'File::HomeDir',
  'File::Path',
  'File::Spec',
  'File::Temp',
  'File::Util',
  'Graph::Directed',
  'Guard',
  'IPC::System::Simple',
  'JSON',
  'JSON::XS',
  'List::MoreUtils',
  'List::Util',
  'Log::Any',
  'Log::Any::Adapter',
  'Log::Any::Adapter::Log4perl',
  'Log::Dispatch::FileRotate',
  'Log::Log4perl',
  'MIME::Base64',
  'Mail::Sendmail',
  'Module::Build',
  'POSIX',
  'Parallel::ForkManager',
  'Params::Validate',
  'PerlIO::Util',
  'REST::Client',
  'Smart::Comments',
  'Switch',
  'Term::ANSIColor',
  'Test::Inter',
  'Test::More',
  'Text::Table',
  'Time::HiRes',
  'Time::Local',
  'WWW::Mechanize',
  'XML::Smart',
  'YAML',
  'local::lib',
]

cpanm { $modules:
  ensure => latest,
}

Package[$deps] -> Cpanm[$modules]
