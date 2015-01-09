use strict;
use warnings FATAL => 'all';
use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use CairoX::Sweet;

ok 1;

my $color = CairoX::Sweet::Color->new(red => 0, green => 0.5, blue => 0.75);

is $color->blue, 0.75, 'Has right amount of blue';

my $c = CairoX::Sweet->new(200, 100, background_color => [210, 120, 123]);

is $c->background_color->red, 210/255, 'background has right amount of red';

$c->line(color => '#ffffff', move => [42, 34], draw => [qw/
	43 23
	45 56
	78 43
/]);

done_testing;
