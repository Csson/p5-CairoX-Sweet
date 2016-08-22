use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Core::CurveTo;

# ABSTRACT: Make a curve_to
# AUTHORITY
our $VERSION = '0.0201';

use CairoX::Sweet::Elk;
use CairoX::Sweet::Core::Point;
use Types::CairoX::Sweet -types;
use Types::Standard qw/ArrayRef Bool/;
with 'CairoX::Sweet::Role::PathCommand';

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

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;
    my $x1 = shift;
    my $y1 = shift;
    my $x2 = shift;
    my $y2 = shift;
    my $x3 = shift;
    my $y3 = shift;

    my %options = @_;
    my $is_relative = $options{'is_relative'} || 0;

    $self->$orig(is_relative => $is_relative, points => [
                                                CairoX::Sweet::Core::Point->new(x => $x1, y => $y1),
                                                CairoX::Sweet::Core::Point->new(x => $x2, y => $y2),
                                                CairoX::Sweet::Core::Point->new(x => $x3, y => $y3)
                                            ]);
};
sub out {
    my $self = shift;
    return map { $_->out } $self->all_points;
}
sub method {
    my $self = shift;
    return $self->is_relative ? 'rel_curve_to' : 'curve_to';
}
sub location {
    my $self = shift;
    return $self->get_point(-1);
}
sub move_location {
    my $self = shift;
    my %params = @_;
    my $x = $params{'x'} || 0;
    my $y = $params{'y'} || 0;

    foreach my $point ($self->all_points) {
        $point->move(x => $x, y => $y);
    }
}

1;
