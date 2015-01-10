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
    # default value sets in BUILDARGS
    has is_relative => (
        is => 'ro',
        isa => Bool,
        required => 1,
    );

    around BUILDARGS($orig: $self, Num $x, Num $y, Bool :$is_relative? = 0) {
        $self->$orig(point => CairoX::Sweet::Core::Point->new(x => $x, y => $y), is_relative => $is_relative);
    }
    method out {
        return $self->point->out;
    }
    method method {
        return $self->is_relative ? 'rel_move_to' : 'move_to';
    }
}
