use 5.14.0;
use strict;
use warnings;
use Moops;

# VERSION
# PODNAME: CairoX::Sweet::Color
# ABSTRACT: Short intro

class CairoX::Sweet::Color types Types::CairoX::Sweet using Moose {

    foreach my $color (qw/red green blue/) {
        has $color => (
            is => 'ro',
            isa => Int,
            required => 1,
        );
    }
    has opacity => (
        is => 'ro',
        isa => UpToOneNum,
    );
    
}
