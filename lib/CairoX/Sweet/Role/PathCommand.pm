use CairoX::Sweet::Standard;
use strict;
use warnings;

# PODCLASSNAME

role CairoX::Sweet::Role::PathCommand using Moose {

    # VERSION
    requires 'location', 'move_location';
}

1;
