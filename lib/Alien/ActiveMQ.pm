package Alien::ActiveMQ;
use Moose;
use Method::Signatures::Simple;
use File::ShareDir qw/dist_dir/;
use Path::Class qw/file dir/;
use Scope::Guard;
use namespace::autoclean;

my $VERSION = 0.00001;

method get_installed_versions {}

method get_version_dir ($version) {}

method is_version_installed ($version) {}

method run_server ($version) {
    if (!$version) {
        #$version = ( $self->get_installed_versions )[0];
    }
    my $dir = dir( dist_dir('Alien-ActiveMQ'), '5.2.0' );
    warn("Running $dir");
    my $file = file( $dir, 'bin', 'activemq' );
    system("$file &"); # LAME AS A LAME THING, Use IPC::Cmd here
                       # Need to fork, get child PID to pass into the scope guard
                       # and it would be nice to be able to grab the output of the server,
                       # and wait till it said it was started etc..
    
    sleep 20;
    return Scope::Guard->new(sub { system("killall java") });
}

1;

__END__

=head1 NAME

Alien::ActiveMQ - Manages installs of versions of Apache ActiveMQ, and provides a standard way to start an MQ server from perl.

=head1 SYNOPSIS

    use Alien::ActiveMQ;

    {
        my $mq = Alien::ActiveMQ::run_server
        
        # Apache MQ is now running on the default port, you
        # can now test your Net::Stomp based code
    }
    # And Apache MQ shuts down once $mq goes out of scope here.

=head1 FUNCTIONS

=head2 run_server ([ $version ])

Runs an ActiveMQ server instance for you.

Returns a value which you must keep in scope until you want the ActiveMQ server
to shutdown.

=cut

