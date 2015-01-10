use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::Path
# ABSTRACT: Short intro

class CairoX::Sweet::Path using Moose {

    use Type::Utils qw/enum/;
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
    has cap => (
        is => 'rw',
        isa => enum([qw/butt round square/]),
        default => 'butt',
    );
    has join => (
        is => 'rw',
        isa => enum([qw/miter round bevel/]),
        default => 'miter',
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
    around BUILDARGS($orig: $self, @args) {
        my %args = @args;
        if(exists $args{'start'}) {
            $args{'start'} = CairoX::Sweet::Core::MoveTo->new(@{ $args{'start'} }, is_relative => 0);
        }
        elsif(exists $args{'move'}) {
            $args{'move'} = CairoX::Sweet::Core::MoveTo->new(@{ $args{'move'} }, is_relative => 1);
        }
        $self->$orig(%args);
    }
    method BUILD {
        if($self->has_start) {
            $self->add_command($self->start);
        }
        elsif($self->has_move) {
            $self->add_command($self->move);
        }
    }
    method purge {
        $self->commands([]);
    }

    method my $add_move($is_relative, @values) {
        while(scalar @values >= 2) {
            $self->add_command(CairoX::Sweet::Core::MoveTo->new(splice(@values, 0, 2), is_relative => $is_relative));
        }
        return $self;
    }
    method add_start(@values) {
        return $self->$add_move(0, @values);
    }
    method add_move(@values) {
        return $self->$add_move(1, @values);
    }

    method my $add_line($is_relative, @values) {
        while(scalar @values >= 2) {
            $self->add_command(CairoX::Sweet::Core::LineTo->new(splice(@values, 0, 2), is_relative => $is_relative));
        }
        return $self;
    }
    method add_line(@values) {
        return $self->$add_line(0, @values);
    }
    method add_relative_line(@values) {
        return $self->$add_line(1, @values);
    }

    method add_curve(@values) {
        while(scalar @values >= 6) {
            $self->add_command(CairoX::Sweet::Core::CurveTo->new(splice(@values, 0,6), is_relative => 0));
        }
        return $self;
    }
    method add_relative_curve(@values) {
        while(scalar @values >= 6) {
            $self->add_command(CairoX::Sweet::Core::CurveTo->new(splice(@values, 0, 6), is_relative => 1));
        }
        return $self;
    }
}
