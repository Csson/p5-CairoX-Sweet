use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

# VERSION
# PODNAME: CairoX::Sweet::MultiPath
# ABSTRACT: Short intro

class CairoX::Sweet::MultiPath using Moose {

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
    has colors => (
        is => 'rw',
        isa => ArrayRef[Color],
        coerce => 1,
        predicate => 1,
        traits => ['Array'],
        default => sub { [] },
        handles => {
            count_colors => 'count',
            all_colors => 'elements',
            map_colors => 'map',
        },
    );
    has widths => (
        is => 'rw',
        isa => ArrayRef[Num],
        predicate => 1,
        traits => ['Array'],
        default => sub { [] },
        handles => {
            count_widths => 'count',
            all_widths => 'elements',
            map_widths => 'map',
        },
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
    has paths => (
        is => 'rw',
        isa => ArrayRef,
        traits => ['Array'],
        handles => {
            add_path => 'push',
            all_paths => 'elements',
        },
    );
    around BUILDARGS($orig: $self, @args) {
        my %args = @args;

        if(scalar @{ $args{'color'} } != scalar @{ $args{'width'} }) {
            die "Needs same amount of 'color' and 'width'";
        }
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


    method total_width {
        return $self->count_widths + sum($self->all_widths);
    }
    method draw_relative_lines(@values) {
        while(scalar @values > 2) {
            my($x, $y) = splice @values, 0 => 2;
            my $nextx = $values[0];
            my $nexty = $values[1];

            m
        }
    }
}
