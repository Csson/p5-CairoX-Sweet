use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

package CairoX;

use Cairo;

# VERSION
# ABSTRACT: Short intro

class Sweet using Moose {
    
    
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
    has background => (
        is => 'ro',
        isa => Maybe[Color],
        predicate => 1,
        coerce => 1,
    );
    has context => (
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
        $args{'context'} = Cairo::Context->create($args{'surface'}) if !exists $args{'context'};

        $self->$orig(%args);
    }

    method BUILD {
        if($self->has_background) {
            $self->context->rectangle(0, 0, $self->width, $self->height);
            $self->context->set_source_rgb($self->background->color);
            $self->context->fill;
        }
    }

    method line(HashRef $settings, @data) {
        
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
