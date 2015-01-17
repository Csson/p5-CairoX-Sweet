use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODCLASSNAME

class CairoX::Sweet::Color using Moose {

    foreach my $color (qw/red green blue/) {
        has $color => (
            is => 'ro',
            isa => NumUpToOne,
            required => 1,
        );
    }
    has opacity => (
        is => 'ro',
        default => 1,
        isa => NumUpToOne,
    );

    method color {
        return ($self->red, $self->green, $self->blue);
    }
    method color_with_opacity {
        return ($self->red, $self->green, $self->blue, $self->opacity);
    }
}

1;
