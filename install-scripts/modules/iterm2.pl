# iterm2.pl --- iTerm2 installer
# author: Seong Yong-ju <sei40kr@gmail.com>

use utf8;
use strict;
use warnings;

if (&is_macos) {
    brew_cask_install('iterm2');

    ln( 'iterm2', "${ENV{HOME}}/iterm2_profile" );

    # Download imgcat
    curl(
        'https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/imgcat',
        "${ENV{HOME}}/.local/bin/imgcat"
    );
    # TODO Give executable permission to imgcat

    # Specify the preferences directory
    defaults_write_string( 'com.googlecode.iterm2.plist', 'PrefsCustomFolder',
        "${ENV{HOME}}/iterm2_profile" );

    # Tell iTerm2 to use the custom preferences in the directory
    defaults_write_bool( 'com.googlecode.iterm2.plist',
        'LoadPrefsFromCustomFolder', 1 );
}

1;
