# launchctl.pl --- launchctl facade
# author: Seong Yong-ju <sei40kr@gmail.com>

use utf8;
use strict;
use warnings;
use File::Basename qw(dirname);
use Cwd qw(realpath);

my @sudo_launchctl_load_intermediate = ();
my @launchctl_load_intermediate      = ();

sub sudo_launchctl_load {
    my $src = $_[0];

    push( @sudo_launchctl_load_intermediate, $src );
}

sub launchctl_load {
    my $src = $_[0];

    push( @launchctl_load_intermediate, $src );
}

my sub sudo_launchctl_load_reducer {
    return if ( scalar(@sudo_launchctl_load_intermediate) eq 0 );

    error('launchctl not found.') unless (&is_macos);

    log_wait('Enabling launchctl system-wide services ...');

    Command::run( qw(sudo launchctl load -w), @sudo_launchctl_load_intermediate );
}

my sub launchctl_load_reducer {
    return if ( scalar(@launchctl_load_intermediate) eq 0 );

    error('launchctl not found.') unless (&is_macos);

    log_wait('Enabling launchctl services ...');

    Command::run( qw(launchctl load -w), @launchctl_load_intermediate );
}

register_reducer( 40, \&sudo_launchctl_load_reducer );
register_reducer( 41, \&launchctl_load_reducer );

1;
