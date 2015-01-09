use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

package CairoX;

use Cairo;

# VERSION
# ABSTRACT: Short intro

class Sweet using Moose {
    
    use CairoX::Sweet::Color;
    use aliased 'CairoX::Sweet::Core::LineTo';
    use aliased 'CairoX::Sweet::Core::MoveTo';
    
    has surface_format => (
        is => 'ro',
        isa => Str,
    );
    has width => (
        is => 'ro',
        isa => Int,
        required => 1,
    );
    has height => (
        is => 'ro',
        isa => Int,
        required => 1,
    );
    has background_color => (
        is => 'ro',
        isa => Maybe[Color],
        predicate => 1,
        coerce => 1,
    );
    has path => (
        is => 'rw',
        isa => Path,
    );
    
    has c => (
        is => 'ro',
        isa => CairoContext,
    );
    
    has surface => (
        is => 'ro',
        isa => CairoImageSurface,
    );

    around BUILDARGS($orig: $self, Int $width, Int $height, @args) {
        my %args = @args;

        $args{'width'} = $width;
        $args{'height'} = $height;
        $args{'surface_format'} = 'argb32' if !exists $args{'surface_format'};
        $args{'surface'} = Cairo::ImageSurface->create($args{'surface_format'}, $args{'width'}, $args{'height'}) if !exists $args{'surface'};
        $args{'c'} = $args{'context'} // $args{'c'} // Cairo::Context->create($args{'surface'});
        delete $args{'context'};

        $self->$orig(%args);
    }

    method BUILD {
        if($self->has_background_color) {
            $self->c->rectangle(0, 0, $self->width, $self->height);
            $self->c->set_source_rgb($self->background_color->color);
            $self->c->fill;
        }
    }

    method draw(Str :$method!,
                Int :$num_per_iteration,
                Maybe[Color] :$color? does coerce,
                Maybe[Color] :$background_color? does coerce,
                ArrayRefNumOfTwo :$move = [],
                Bool :$stop!,
                ArrayRef[Num] :$draw = [],
    ){

        if(scalar @$move) {
            $self->path->add(MoveTo->new(@$move));
        }
        my $move_to_x = shift @$move if scalar @$move;
        my $move_to_y = shift @$move if scalar @$move;

        if(defined $background_color) {
            $self->c->set_source_rgb($background_color->color);

            if(scalar @$move) {
                $self->c->move_to($move_to_x, $move_to_y);
            }
            if($method eq 'line_to') {
                $self->path->add(LineTo->new($draw->[0], $draw->[1]));
            }

            DRAW:
            while(scalar @$draw) {
                $self->c->$method(splice @$draw, 0, $num_per_iteration);
            }
            if($stop) {
                $self->c->fill;
            }

        }
        if((defined $background_color && defined $color) || !defined $background_color) {
    
            $self->c->set_source_rgb($color->color) if defined $color;

            if(scalar @$move) {
                $self->c->move_to($move_to_x, $move_to_y);
            }
            DRAW:
            while(scalar @$draw) {
                $self->c->$method(splice @$draw, 0, $num_per_iteration);
            }
            if($stop && defined $color) {
                $self->c->stroke;
            }
        }
    }

    method line(Color :$color does coerce, Color :$background_color? does coerce, ArrayRefNumOfTwo :$move = [], Bool :$stop = 1, ArrayRefNumOfTwo :$draw?) {
        $self->draw(method => 'line_to', num_per_iteration => 2, eh $draw, $move, $stop, $color, $background_color);
    }
    method curve(Color :$color does coerce, Color :$background_color? does coerce, ArrayRefNumOfTwo :$move = [], Bool :$stop = 1, ArrayRefNumOfSix :$draw?) {
        $self->draw(method => 'curve_to', num_per_iteration => 6    , eh $draw, $move, $stop, $color, $background_color);
    }
}





__END__

=pod

=encoding utf-8

=head1 SYNOPSIS

    use CairoX::Sweet;

=head1 DESCRIPTION

CairoX::Sweet is ...

=head1 SEE ALSO

=cut
