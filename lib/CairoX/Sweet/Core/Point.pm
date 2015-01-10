use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Core::Point
# ABSTRACT: Short intro

class CairoX::Sweet::Core::Point using Moose {

    has x => (
        is => 'rw',
        isa => Num,
        required => 1,
    );
    has y => (
        is => 'rw',
        isa => Num,
        required => 1,
    );
    
    method out {
        return ($self->x, $self->y);
    }
    method move(:$x = 0, :$y = 0) {
        $self->x($self->x + $x);
        $self->y($self->y + $y);
    }
}
