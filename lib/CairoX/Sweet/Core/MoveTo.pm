use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Core::MoveTo;

# ABSTRACT: Make a move_to
# AUTHORITY
our $VERSION = '0.0201';

use CairoX::Sweet::Elk;
use CairoX::Sweet::Core::Point;
use Types::CairoX::Sweet -types;
use Types::Standard qw/Bool/;

with 'CairoX::Sweet::Role::PathCommand';

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

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;
    my $x = shift;
    my $y = shift;

    my %options = @_;
    my $is_relative = $options{'is_relative'} || 0;

    $self->$orig(point => CairoX::Sweet::Core::Point->new(x => $x, y => $y), is_relative => $is_relative);
};
sub out {
    my $self = shift;
    return $self->point->out;
}
sub method {
    my $self = shift;
    return $self->is_relative ? 'rel_move_to' : 'move_to';
}
sub location {
    my $self = shift;
    return $self->point;
}
sub move_location {
    my $self = shift;
    my %params = @_;
    my $x = $params{'x'} || 0;
    my $y = $params{'y'} || 0;

    $self->point->move(x => $x, y => $y);
}

1;
