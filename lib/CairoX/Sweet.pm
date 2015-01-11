use 5.14.0;
use strict;
use warnings;
use CairoX::Sweet::Standard;

package CairoX;

use Cairo;

# VERSION
# ABSTRACT: Wraps Cairo for easier drawing

class Sweet using Moose {

    use Type::Utils qw/enum/;
    use Types::Path::Tiny qw/AbsPath/;
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
    has filename => (
        is => 'rw',
        isa => Maybe[AbsPath],
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
    method new_svg($class: Int $width!, Int $height!, AbsPath $filename! does coerce, @args) {
        my %args = @args;
        $args{'surface'} = Cairo::SvgSurface->create($filename, $width, $height);
        $args{'filename'} = $filename;
        return $class->new($width, $height, %args);
    }

    method add_path(Path $path, :$close = 0) {
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
            $self->c->close_path if $close;
            $self->c->stroke;
        }
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

    my $c = CairoX::Sweet->new(500, 500, '#ffffff');
    my $path = CairoX::Sweet::Path->new(start => [35, 50], color => '#8855bb', width => 10, cap => 'round', join => 'round');

    $path->add_relative_line(qw/
        20 -5
        10 0
        30 -20
        -50 0
    /);
    $c->add_path($path, close => 1);

    $c->surface->write_to_png('a_short_line.png');

=head1 DESCRIPTION

CairoX::Sweet is a wrapper around L<Cairo> which uses the great L<cairo|http://www.cairographics.org/> graphics library.

For some use cases the standard api is a little verbose, the goal of this distribution is to reduce that.


=head1 CONSTRUCTORS

=head2 new($width, $height, %args)

    my $c = CairoX::Sweet->new(700, 500);
    my $c = CairoX::Sweet->new(700, 500, surface_format => 'argb32');

Both of these does this:

    my $surface = Cairo::ImageSurface->create('argb32', 700, 500);
    my $context = Cairo::Context->create($surface);

Use this constructor if you want to save the output as a png file later.


=head2 new_svg($width, $height, $filename, %args)

    my $c = CairoX::Sweet->new_svg(700, 500, 'output.svg');

Does this:

    Cairo::SvgSurface->create($filename, $width, $height);

Use this constructor if you want to save the output as an svg file later


=head1 ATTRIBUTES

=head2 width

=head2 height

    my $c = CairoX::Sweet->new(700, 500);

Integers. Required. The width and height of the surface.

=head2 background_color

    my $c1 = CairoX::Sweet->new(..., background_color => '#83f9e2');
    my $c2 = CairoX::Sweet->new(..., background_color => [220, 75, 230]);
    my $c3 = CairoX::Sweet->new(..., background_color => [0.2, 0.4, 0.6]);

String or array reference of numbers. Optional. The starting background color.

You can pick one of three ways to give a color:

=for :list
* As a hexadecimal string
* As an array reference giving a number each for red, green and blue (between 0 and 255).
* As an array reference in fractions between 0 and 1. This is the C<cairo> style. B<Note:> A color given as C<[1, 1, 1]> is interpreted as (nearly) black, and not white as C<cairo> would do.


=head2 filename

    my $c = CairoX::Sweet->new_svg(..., filename => 'mysvg.svg');

String or a L<Path::Tiny> path. Required for L<new_svg|/"new_svg($width, $height, $filename, %args)">.


=head1 METHODS


=head2 add_path()

Adds a L<CairoX::Sweet::Path> to the C<cairo> object.

    $c->add_path($path, close => 1);

C<$path>

The L<CairoX::Sweet::Path> to add. Required.

C<close => Bool>

Boolean. Optional named parameter, defaults to C<0>. If positive, will call C<close_path|http://cairographics.org/manual/cairo-Paths.html#cairo-close-path>
on the C<$path> (connects the two end points of the C<$path>).


=head2 add_text()

Adds a string to the C<cairo> object. Takes only named parameters.

    $c->add_text( text => "The text to add",
                  color => '#444444',
                  x => 37,
                  y => 115,
                  font_face => ['courier'],
                  font_size => 13
                  weight => 'bold',
    );

C<text => 'the text'>

String. The only required parameter. The text to add.

C<x>

C<y>

Integers. The position to start at.

C<color>

A color. The color of the text. See L</"background_color"> for more information on colors.

C<font_face>

An array reference of font faces. There is no list of available font faces.

C<font_size>

Number. The size of the text. Default is C<10>.

C<weight>

One of C<normal> or C<bold>.

C<slant>

One of C<normal>, C<italic> or C<oblique>.


=head2 c()

Returns the L<Cairo> object itself.

    $c->c->set_source_rgb(0.4, 0.3, 0.2);
    $c->c->set_line_cap('round');
    $c->c->arc(150, 200, 35, 0, 3.1415);
    $c->c->stroke;

=head2 surface()

Return the L<Cairo surface|https://metacpan.org/pod/Cairo#Surfaces>.

    $c->surface->write_to_png('a_short_line.png');

=head1 STABILITY

Since this is an early release things might break, but hopefully not without good cause.

=head1 PERFORMANCE

Using both L<Moose> and L<Moops> adds a little startup cost. If you need performance it is recommended to use L<Cairo> directly.

=head1 SEE ALSO

=for :list
* L<CairoX::Sweet::Path>
* L<Cairo>

=cut
