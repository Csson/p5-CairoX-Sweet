use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::CurveTo
# ABSTRACT: Short intro

class CairoX::Sweet::Core::CurveTo using Moose {

    use CairoX::Sweet::Core::Point;

    has points => (
        is => 'ro',
        isa => ArrayRef[Point],
        traits => ['Array'],
        required => 1,
        handles => {
        	all_points => 'elements',
        }
    );
    has is_relative => (
        is => 'ro',
        isa => Bool,
        required => 1,
    );

    around BUILDARGS($orig: $self, Num $x1, Num $y1, Num $x2, Num $y2, Num $x3, Num $y3, Bool :$is_relative = 0) {
        $self->$orig(is_relative => $is_relative, point => CairoX::Sweet::Core::Point->new(x => $x, y => $y));
    }
}
