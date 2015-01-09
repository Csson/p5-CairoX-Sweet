use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::Path
# ABSTRACT: Short intro

class CairoX::Sweet::Core::Path using Moose {

    has commands => (
        is => 'rw',
        isa => ArrayRef,
        traits => ['Array'],
        handles => {
            add => 'push',
            all_commands => 'elements',
        },
    );
    
}
