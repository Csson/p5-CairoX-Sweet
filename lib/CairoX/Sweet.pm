use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

package CairoX;

# VERSION
# ABSTRACT: Short intro

class Sweet using Moose {
    
    use Cairo;
    
    has surface_format => (
        is => 'ro',
        isa => Str,
        default => 'argb32',
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
        isa => Color,
    );
    
    
    
    
    has surface => (
        is => 'ro',
        isa => CairoFormat,
        lazy => 1,
    );



    method BUILD {
        my $surface = Cairo::ImageSurface->create
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
