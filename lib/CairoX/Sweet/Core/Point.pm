use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Core::Point;

# ABSTRACT: Defines a point
# AUTHORITY
# VERSION

use CairoX::Sweet::Elk;
use Types::Standard -types;

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

sub out {
    my $self = shift;
    return ($self->x, $self->y);
}
sub move {
    my $self = shift;
    my %params = @_;
    my $x = $params{'x'} || 0;
    my $y = $params{'y'} || 0;
    $self->x($self->x + $x);
    $self->y($self->y + $y);
}

1;
