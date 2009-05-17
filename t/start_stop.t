#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 1;
use Test::Exception;

use Alien::ActiveMQ;

plan 'skip_all' => 'No installed versions of ActiveMQ, cannot test'
    unless (Alien::ActiveMQ->is_version_installed());

lives_ok {
    my $mq = Alien::ActiveMQ->run_server;
} 'Can start and stop ActiveMQ server';

