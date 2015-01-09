use 5.14.0;
use warnings;

use Moops;

# VERSION
# PODNAME: Types::CairoX::Sweet
# ABSTRACT:

library Types::CairoX::Sweet

extends Types::Standard

declares CairoImageSurface,
         CairoContext,
         UpToOneNum,
         Color

{
    use List::AllUtils qw/any zip/;

    class_type CairoContext      => { class => 'Cairo::Context' };
    class_type CairoImageSurface => { class => 'Cairo::ImageSurface' };

    class_type Color   => { class => 'CairoX::Sweet::Color' };

    declare UpToOneNum, as Num,
        where { $_ >= 0 && $_ <= 1 },
        message {
            return Num->get_message($_)  if !Num->check($_);
            return "$_ is too small. Minimum allowed value is 0" if $_ < 0;
            return "$_ is too big. Maximum allowed value is 1";
        };

    coerce Color,
        from Str,       via {
            my $str = $_;
            $str =~ s{^#}{};
            if($str =~ m{^([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$}i) {
                "CairoX::Sweet::Color"->new(red => (hex $1) / 255, green => (hex $2) / 255, blue => (hex $3) / 255 );
            }
        },
        from ArrayRef,  via {
            my @array = @{ $_ };
            if(scalar @array == 3 || scalar @array == 4) {
                my $opacity = scalar @array == 4 ? pop @array : undef;

                my @colors = qw/red green blue/;
                if(any { int $_ != $_ } @array) {
                    @colors = zip (@colors, @array);
                }
                else {
                    @array = map { $_ / 255 } @array;
                    @colors = zip (@colors, @array);
                }
                my %color = @colors;
                $color{'opacity'} = $opacity if defined $opacity;

                "CairoX::Sweet::Color"->new(%color);
            }
        };
}

1;
