#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$Bin/;
BEGIN {
    $ENV{PATH} = "$Bin/start_broken_java:" . $ENV{PATH};
}

use Test::More;
use Test::Exception;

use Alien::ActiveMQ;

unless (Alien::ActiveMQ->is_version_installed()) {
    plan 'skip_all' => 'No installed versions of ActiveMQ, cannot test';
    exit 0;
}

plan tests => 1;

throws_ok {
    my $mq = Alien::ActiveMQ->run_server;
} qr/Could not start ActiveMQ server: Failed to execute main task/,
    'Test error thrown when Java does not start';

