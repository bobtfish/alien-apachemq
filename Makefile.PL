use inc::Module::Install 0.78;

name 'Alien-ActiveMQ';
all_from 'lib/Alien/ActiveMQ.pm';
license 'apache';

requires 'Moose';
requires 'MooseX::Getopt';
requires 'MooseX::Types';
requires 'MooseX::Types::Path::Class';
requires 'Method::Signatures::Simple';
requires 'namespace::autoclean';
requires 'File::ShareDir';
requires 'Path::Class';
requires 'File::Temp';
requires 'LWP';
requires 'Archive::Extract';
requires 'IPC::Run';
requires 'Scope::Guard';

install_share 'share';
install_script 'script/install-activemq';

postamble(<<EOF);
install ::
\t$^X script/install-activemq
EOF

auto_install;
WriteAll();

