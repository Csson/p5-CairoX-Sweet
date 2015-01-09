use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Path
# ABSTRACT: Short intro

class CairoX::Sweet::Path using Moose {

    use CairoX::Sweet::Core::LineTo;

    has move => (
        is => 'rw',
        isa => Maybe[MoveTo],
        predicate => 1,
        coerce => 1,
    );
    has start => (
        is => 'rw',
        isa => Maybe[MoveTo],
        predicate => 1,
        coerce => 1,
    );
    has color => (
        is => 'rw',
        isa => Maybe[Color],
        coerce => 1,
        predicate => 1,
    );
    has background_color => (
        is => 'rw',
        isa => Maybe[Color],
        coerce => 1,
        predicate => 1,
    );
    has width => (
        is => 'rw',
        isa => Maybe[Num],
        predicate => 1,
    );
    has commands => (
        is => 'rw',
        isa => ArrayRef,
        traits => ['Array'],
        handles => {
            add_command => 'push',
            all_commands => 'elements',
        },
    );
    method BUILD {
        if($self->has_start) {
            $self->add_command(CairoX::Sweet::Core::MoveTo->new($self->start, is_relative => 0));
        }
        elsif($self->has_move) {
            $self->add_command(CairoX::Sweet::Core::MoveTo->new($self->move, is_relative => 1));
        }
    }
    method purge {
        $self->commands([]);
    }

    method add_line(@values) {
        while(scalar @values >= 2) {
            $self->add_command(CairoX::Sweet::Core::LineTo->new(splice(@values, 0, 2), is_relative => 0);
        }
        return $self;
    }
    method add_relative_line(@values) {
        while(scalar @values >= 2) {
            $self->add_command(CairoX::Sweet::Core::LineTo->new(splice(@values, 0, 2), is_relative => 1);
        }
        return $self;
    }
    method add_curve(@values) {
        while(scalar @values >= 6) {
            $self->add_command(CairoX::Sweet::Core::LineTo->new(splice(@values, 0,6), is_relative => 0);
        }
        return $self;
    }
    method add_relative_curve(@values) {
        while(scalar @values >= 6) {
            $self->add_command(CairoX::Sweet::Core::LineTo->new(splice(@values, 0, 6), is_relative => 1);
        }
        return $self;
    }
}
