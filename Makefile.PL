use inc::Module::Install 0.78;

name 'Alien-ActiveMQ';
all_from 'lib/Alien/ActiveMQ.pm';
license 'apache';
requires 'File::ShareDir';

install_share 'share';

auto_install;
WriteAll();

