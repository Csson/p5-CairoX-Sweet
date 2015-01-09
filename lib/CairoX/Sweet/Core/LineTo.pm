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
    has is_relative => (
        is => 'ro',
        isa => Bool,
        required => 1,
    );

    around BUILDARGS($orig: $self, Num $x, Num $y, Bool :$is_relative = 0) {
        $self->$orig(is_relative => $is_relative, point => CairoX::Sweet::Core::Point->new(x => $x, y => $y));
    }
}