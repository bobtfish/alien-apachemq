#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

use Alien::ActiveMQ;

unless (Alien::ActiveMQ->is_version_installed()) {
    plan 'skip_all' => 'No installed versions of ActiveMQ, cannot test';
    exit 0;
}

plan tests => 1;

lives_ok {
    my $mq = Alien::ActiveMQ->run_server;
} 'Can start and stop ActiveMQ server';

