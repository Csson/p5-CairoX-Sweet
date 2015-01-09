use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::LineTo
# ABSTRACT: Short intro

class CairoX::Sweet::Core::LineTo using Moose {

    use CairoX::Sweet::Core::Point;

    has point => (
        is => 'ro',
        isa => Point,
        required => 1,
    );

    around BUILDARGS($orig: $self, Num $x, Num $y) {
        $self->$orig(CairoX::Sweet::Core::Point->new(x => $x, y => $y));
    }
}
