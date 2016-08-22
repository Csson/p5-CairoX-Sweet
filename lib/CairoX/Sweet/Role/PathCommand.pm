use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Role::PathCommand;

# AUTHORITY
# VERSION

use Moose::Role;

requires qw/
    location
    move_location
/;

1;
