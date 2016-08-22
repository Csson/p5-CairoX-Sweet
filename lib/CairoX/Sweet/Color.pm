use 5.10.0;
use strict;
use warnings;

# PODCLASSNAME

package CairoX::Sweet::Color;

# AUTHORITY
# VERSION

use CairoX::Sweet::Elk;
use Types::CairoX::Sweet -types;

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

sub color {
    my $self = shift;
    return ($self->red, $self->green, $self->blue);
}
sub color_with_opacity {
    my $self = shift;
    return ($self->red, $self->green, $self->blue, $self->opacity);
}

1;
