use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::CurveTo
# ABSTRACT:

class CairoX::Sweet::Core::CurveTo with CairoX::Sweet::Role::PathCommand using Moose {

    use CairoX::Sweet::Core::Point;

    has points => (
        is => 'ro',
        isa => ArrayRef[Point],
        traits => ['Array'],
        required => 1,
        handles => {
            all_points => 'elements',
            get_point => 'get',
        }
    );
    has is_relative => (
        is => 'ro',
        isa => Bool,
        required => 1,
    );

    around BUILDARGS($orig: $self, Num $x1, Num $y1, Num $x2, Num $y2, Num $x3, Num $y3, Bool :$is_relative = 0) {
        $self->$orig(is_relative => $is_relative, points => [
                                                    CairoX::Sweet::Core::Point->new(x => $x1, y => $y1),
                                                    CairoX::Sweet::Core::Point->new(x => $x2, y => $y2),
                                                    CairoX::Sweet::Core::Point->new(x => $x3, y => $y3)
                                                ]);
    }
    method out {
        return map { $_->out } $self->all_points;
    }
    method method {
        return $self->is_relative ? 'rel_curve_to' : 'curve_to';
    }
    method location {
        return $self->get_point(-1);
    }
    method move_location(:$x = 0, :$y = 0) {
        foreach my $point ($self->all_points) {
            $point->move(x => $x, y => $y);
        }
    }
}
