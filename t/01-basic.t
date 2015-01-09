use strict;
use warnings FATAL => 'all';
use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use CairoX::Sweet;
use CairoX::Sweet::Color;

# replace with the actual test
ok 1;

my $color = CairoX::Sweet::Color->new(red => 1, blue => 2, green => 3, opacity => 2);

done_testing;
