use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::Point
# ABSTRACT: Short intro

class CairoX::Sweet::Core::Point using Moose {

    has x => (
        is => 'ro',
        isa => Num,
        required => 1,
    );
    has y => (
        is => 'ro',
        isa => Num,
        required => 1,
    );
    
}
