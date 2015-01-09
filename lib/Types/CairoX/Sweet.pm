use 5.14.0;
use warnings;

use Moops;

library Types::CairoX::Sweet

extends Types::Standard

declares CairoFormat, UpToOneNum

{
    class_type CairoFormat   => { class => 'Cairo::Format' };

    declare UpToOneNum, as Num,
    	where { $_ >= 0 && $_ <= 1 },
    	message {
    		return Num->get_message($_)  if !Num->check($_);
    		return "$_ must be at least 0 (but not larger than 1)" if $_ < 0;
    		return "$_ must be no more than 1 (but not less than 0)";
    	};

}
