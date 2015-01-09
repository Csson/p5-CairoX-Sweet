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
            isa => UpToOneNum,
            required => 1,
        );
    }
    has opacity => (
        is => 'ro',
        default => 1,
        isa => UpToOneNum,
    );
    
    method color {
        return ($self->red, $self->green, $self->blue);
    }
    method color_with_opacity {
        return ($self->red, $self->green, $self->blue, $self->opacity);
    }
}
