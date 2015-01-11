# NAME

CairoX - Wraps Cairo for easier drawing

# VERSION

Version 0.0102, released 2015-01-11.

# SYNOPSIS

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

# DESCRIPTION

CairoX::Sweet is a wrapper around [Cairo](https://metacpan.org/pod/Cairo) which uses the great [cairo](http://www.cairographics.org/) graphics library.

For some use cases the standard api is a little verbose, the goal of this distribution is to reduce that.

# STABILITY

Since this is an early release things might break, but hopefully not without good cause.

# CONSTRUCTORS

## new($width, $height, %args)

    my $c = CairoX::Sweet->new(700, 500);
    my $c = CairoX::Sweet->new(700, 500, surface_format => 'argb32');

Both of these does this:

    my $surface = Cairo::ImageSurface->create('argb32', 700, 500);
    my $context = Cairo::Context->create($surface);

Use this constructor if you want to save the output as a png file later.

## new\_svg($width, $height, $filename, %args)

    my $c = CairoX::Sweet->new_svg(700, 500, 'output.svg');

Does this:

    Cairo::SvgSurface->create($filename, $width, $height);

Use this constructor if you want to save the output as an svg file later

# ATTRIBUTES

## width

## height

    my $c = CairoX::Sweet->new(700, 500);

Integers. Required. The width and height of the surface.

## background\_color

    my $c1 = CairoX::Sweet->new(..., background_color => '#83f9e2');
    my $c2 = CairoX::Sweet->new(..., background_color => [220, 75, 230]);
    my $c3 = CairoX::Sweet->new(..., background_color => [0.2, 0.4, 0.6]);

String or array reference of numbers. Optional. The starting background color.

You can pick one of three ways to give a color:

- As a hexadecimal string
- As an array reference giving a number each for red, green and blue (between 0 and 255).
- As an array reference in fractions between 0 and 1. This is the `cairo` style. **Note:** A color given as `[1, 1, 1]` is interpreted as (nearly) black, and not white as `cairo` would do.

## filename

    my $c = CairoX::Sweet->new_svg(..., filename => 'mysvg.svg');

String or a [Path::Tiny](https://metacpan.org/pod/Path::Tiny) path. Required for [new\_svg](#new_svg-width-height-filename-args).

# METHODS

## add\_path()

Adds a [CairoX::Sweet::Path](https://metacpan.org/pod/CairoX::Sweet::Path) to the `cairo` object.

    $c->add_path($path, close => 1);

`$path`

The [CairoX::Sweet::Path](https://metacpan.org/pod/CairoX::Sweet::Path) to add. Required.

`close =` Bool>

Boolean. Optional named parameter, defaults to `0`. If positive, will call `close_path|http://cairographics.org/manual/cairo-Paths.html#cairo-close-path`
on the `$path` (connects the two end points of the `$path`).

## add\_text()

Adds a string to the `cairo` object. Takes only named parameters.

    $c->add_text( text => "The text to add",
                  color => '#444444',
                  x => 37,
                  y => 115,
                  font_face => ['courier'],
                  font_size => 13
                  weight => 'bold',
    );

`text =` 'the text'>

String. The only required parameter. The text to add.

`x`

`y`

Integers. The position to start at.

`color`

A color. The color of the text. See ["background\_color"](#background_color) for more information on colors.

`font_face`

An array reference of font faces. There is no list of available font faces.

`font_size`

Number. The size of the text. Default is `10`.

`weight`

One of `normal` or `bold`.

`slant`

One of `normal`, `italic` or `oblique`.

## c()

Returns the [Cairo](https://metacpan.org/pod/Cairo) object itself.

    $c->c->set_source_rgb(0.4, 0.3, 0.2);
    $c->c->set_line_cap('round');
    $c->c->arc(150, 200, 35, 0, 3.1415);
    $c->c->stroke;

## surface()

Return the [Cairo surface](https://metacpan.org/pod/Cairo#Surfaces).

    $c->surface->write_to_png('a_short_line.png');

# PERFORMANCE

Using both [Moose](https://metacpan.org/pod/Moose) and [Moops](https://metacpan.org/pod/Moops) adds a little startup cost. If you need performance it is recommended to use [Cairo](https://metacpan.org/pod/Cairo) directly.

# SEE ALSO

- [CairoX::Sweet::Path](https://metacpan.org/pod/CairoX::Sweet::Path)
- [Cairo](https://metacpan.org/pod/Cairo)

# SOURCE

[https://github.com/Csson/p5-CairoX-Sweet](https://github.com/Csson/p5-CairoX-Sweet)

# HOMEPAGE

[https://metacpan.org/release/CairoX-Sweet](https://metacpan.org/release/CairoX-Sweet)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Erik Carlsson <info@code301.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
