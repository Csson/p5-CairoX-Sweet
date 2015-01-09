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
    use CairoX::Sweet::Path;
    use CairoX::Sweet::Core::CurveTo;
    use CairoX::Sweet::Core::LineTo;
    use CairoX::Sweet::Core::MoveTo;
    
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

    method add_path(Path $path) {
        if($path->has_background_color) {
            foreach my $command ($path->all_commands) {
                my $method = $command->method;
                $self->c->$method($command->out);
            }
            $self->c->set_source_rgb($path->background_color->color);
            $self->c->fill;
        }
        if(($path->has_background_color && $self->has_color) || !$self->has_background_color) {
            foreach my $command ($path->all_commands) {
                my $method = $command->method;
                $self->c->$method($command->out);
            }
            $self->c->set_source_rgb($path->color->color)) if $path->has_color;
            $self->c->set_line_width($path->width) if $path->has_width;
            $self->c->stroke;
        }
        $path->purge;
    }

#    method draw(TypeTiny :$type!,
#                Maybe[Color] :$color? does coerce,
#                Maybe[Color] :$background_color? does coerce,
#                ArrayRefNumOfTwo :$move = [],
#                Bool :$stop!,
#                ArrayRef[Num] :$draw = [],
#    ){
#
#        my $num_per_iteration = $type->name eq 'CurveTo' ? 6 
#                              : $type->name eq 'LineTo'  ? 2
#                              : $type->name eq 'MoveTo'  ? 2
#                              :                            1
#                              ;
#
#        if(scalar @$move) {
#            $self->path->add_command(CairoX::Sweet::Core::MoveTo->new(@$move));
#        }
#
#        while(scalar @$draw) {
#            my $class = sprintf "CairoX::Sweet::Core::%s", $type->name;
#            $self->path->add_command($class->new(splice @$draw, 0, $num_per_iteration));
#        }
#
#        if($stop) {
#            if(defined $background_color) {
#                warn 'Drawing background';
#                $self->c->set_source_rgb($background_color->color);
#
#                foreach my $command ($self->path->all_commands) {
#                    my $method = $command->method;
#                    $self->c->$method($command->out);
#                }
#                $self->c->fill;
#            }
#            if((defined $background_color && defined $color) || !defined $background_color) {
#                warn 'Drawing foreground';
#                $self->c->set_source_rgb($color->color) if defined $color;
#
#                foreach my $command ($self->path->all_commands) {
#                    my $method = $command->method;
#                    $self->c->$method($command->out);
#                }
#                $self->c->stroke;
#            }
#            $self->path->purge;
#        }
#    }
#
#    method line(Color :$color does coerce, Color :$background_color? does coerce, ArrayRefNumOfTwo :$move = [], Bool :$stop = 0, ArrayRefNumOfTwo :$draw?) {
#        $self->draw(type => LineTo, eh $draw, $move, $stop, $color, $background_color);
#    }
#    method curve(Color :$color does coerce, Color :$background_color? does coerce, ArrayRefNumOfTwo :$move = [], Bool :$stop = 0, ArrayRefNumOfSix :$draw?) {
#        $self->draw(type => CurveTo, eh $draw, $move, $stop, $color, $background_color);
#    }
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
