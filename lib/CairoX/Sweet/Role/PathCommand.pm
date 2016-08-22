use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Role::PathCommand;

# AUTHORITY
our $VERSION = '0.0201';

use Moose::Role;

requires qw/
    location
    move_location
/;

1;
