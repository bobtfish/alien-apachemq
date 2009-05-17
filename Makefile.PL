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
requires 'IPC::Cmd';

install_share 'share';

auto_install;
WriteAll();

