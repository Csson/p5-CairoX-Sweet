use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

package CairoX;

use Cairo;

# VERSION
# ABSTRACT: Short intro

class Sweet using Moose {
    
    use Type::Utils qw/enum/;
    use CairoX::Sweet::Color;
    use CairoX::Sweet::Path;
    use CairoX::Sweet::MultiPath;
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
        isa => CairoSurface,
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
        if(($path->has_background_color && $path->has_color) || !$path->has_background_color) {
            foreach my $command ($path->all_commands) {
                my $method = $command->method;
                $self->c->$method($command->out);
            }
            $self->c->set_line_cap($path->cap);
            $self->c->set_line_join($path->join);
            $self->c->set_source_rgb($path->color->color) if $path->has_color;
            $self->c->set_line_width($path->width) if $path->has_width;
            $self->c->stroke;
        }
        $path->purge;
    }

    method add_text(Num :$x, Num :$y, Color :$color does coerce, Str :$text!, ArrayRef[Str] :$font_face = [], Num  :$font_size, Enum[qw/normal italic oblique/] :$slant = 'normal',  Enum[qw/normal bold/] :$weight = 'normal') {
        $self->c->select_font_face(@{ $font_face }, $slant, $weight) if scalar @$font_face;
        $self->c->set_font_size($font_size) if defined $font_size;
        $self->c->set_source_rgb($color->color) if defined $color;
        $self->c->move_to($x, $y)               if defined $x && defined $y;

        $self->c->show_text($text);
        $self->c->fill;
        
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
