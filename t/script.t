#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use Test::Exception;

BEGIN { require "$Bin/../script/install-activemq"; }

{
    package TestInstall;
    use strict;
    use warnings;
    use base qw/Alien::ActiveMQ::Install/;

    sub _get {}
    sub _getstore {}
    sub _dircopy {} 
}

use Test::More tests => 7;

{
    my $i = TestInstall->new;
    ok $i;
    ok !$i->has_version_number;
    is $i->version_number, '5.2.0';
}
{
    my $i = TestInstall->new( version_number => '9.2.1' );
    ok $i;
    ok $i->has_version_number;
    is $i->version_number, '9.2.1';
}
throws_ok { TestInstall->new( version_number => {} ) } qr/version_number/,
    'throws when version not string';

