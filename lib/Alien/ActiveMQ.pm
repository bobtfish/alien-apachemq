package Alien::ActiveMQ;
use Moose;
use Method::Signatures::Simple;
use File::ShareDir qw/dist_dir/;
use Path::Class qw/file dir/;
use Scope::Guard;
use IPC::Run qw/start/;
use Net::Stomp;
use namespace::autoclean;

our $VERSION = '0.00003';

#method get_installed_versions {}

method get_version_dir ($version) {
    if (!$version) {
        #$version = ( $self->get_installed_versions )[0];
        $version = '5.2.0';
    }
    return dir( dist_dir('Alien-ActiveMQ'), $version );
}

method is_version_installed ($version) {
    -d $self->get_version_dir($version);
}

method get_licence_filename ($version) {
    my $dir = $self->get_version_dir($version);
    return file($dir, 'LICENSE');
}

method run_server ($version) {
    my $dir = $self->get_version_dir($version);
    my @cmd = (file( $dir, 'bin', 'activemq' ));

    # Start activemq in a subprocess
    warn("Running @cmd\n");
    my $h = start \@cmd, \undef;
    my $pid = $h->{KIDS}[0]{PID}; # FIXME!
    # Spin until we can get a connection
    my ($stomp, $loop_count);
    while (! $stomp) {
        if ($loop_count++ > 300) {
            die("Can't connect to ActiveMQ after trying 300 seconds.")
        };
        eval {
            $stomp = Net::Stomp->new( { hostname => 'localhost', port => 61613 } );
        };
        if ($@) {
            sleep 1;
        }
    }

    return Scope::Guard->new(sub {
        warn("Killing ApacheMQ...\n");
        $h ? $h->signal ( "KILL" ) : kill $pid, 15;
    });
}

1;

__END__

=head1 NAME

Alien::ActiveMQ - Manages installs of versions of Apache ActiveMQ, and provides a standard way to start an MQ server from perl.

=head1 SYNOPSIS

    use Alien::ActiveMQ;

    {
        my $mq = Alien::ActiveMQ->run_server
        
        # Apache MQ is now running on the default port, you
        # can now test your Net::Stomp based code
    }
    # And Apache MQ shuts down once $mq goes out of scope here

=head1 DESCRIPTION

This module, along with the bundled C< install-apachemq > script,
helps to manage installations of the Apache ActiveMQ message queueing software,
from L<http://activemq.apache.org>.

=head1 CLASS METHODS

=head2 run_server ([ $version ])

Runs an ActiveMQ server instance for you.

Returns a value which you must keep in scope until you want the ActiveMQ server
to shutdown.

=head2 get_version_dir ([ $version ])

Returns a L<Path::Class::Dir> object to where a particular version of ActiveMQ
is installed.

If a version is not provided, then the latest available version at the time of
writing (5.2.0) is used.

=head2 is_version_installed ([ $version ])

Returns true if the version directory for the supplied version exists.

=head2 get_license_file ([ $version ])

Returns a L<Path::Class::File> object representing the text file containing the
license for a particular version of Apache ActiveMQ.

=head1 TODO

This is the first release of this code, and as such, it is very light on
features, and probably full of bugs.

Please see comments in the code for features planned and changes needed.

Patches (or forks on github) are, as always, welcome.

=head1 LINKS

=over

=item L<http://activemq.apache.org/> - Apache ActiveMQ project homepage.

=item L<Net::STOMP> - Interface to the Streamed Text Oriented Message Protocol in perl.

=item L<Catalyst::Engine::STOMP> - Use the power of Catalyst dispatch to route job requests.

=back

=head1 AUTHORS

    Tomas Doran (t0m) <bobtfish@bobtfish.net>
    Zac Stevens (zts) <zts@cryptocracy.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Tomas Doran.

This is free software; you can redistribute it and/or modify it under the same
terms as perl itself.

Note that the Apache MQ code which is installed by this software is licensed
under the Apache 2.0 license, which is included in the installed software.

=cut

