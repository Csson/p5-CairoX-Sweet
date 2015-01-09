use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::MoveTo
# ABSTRACT: Short intro

class CairoX::Sweet::Core::MoveTo using Moose {

    use CairoX::Sweet::Core::Point;

    has point => (
        is => 'ro',
        isa => Point,
        required => 1,
    );

    multi around BUILDARGS($orig: $self, Num $x, Num $y) {
        $self->$orig(CairoX::Sweet::Core::Point->new(x => $x, y => $y));
    }
}
