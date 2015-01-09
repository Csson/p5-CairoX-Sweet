use strict;
use warnings FATAL => 'all';
use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use CairoX::Sweet;

ok 1;

my $c = CairoX::Sweet->new(200, 100, background => [210, 120, 123]);
done_testing;
