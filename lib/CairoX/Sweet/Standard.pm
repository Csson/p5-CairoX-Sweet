use 5.20.0;

# VERSION

package CairoX::Sweet::Standard::Moops {

    use base 'Moops';
    use CairoX::Sweet::Types();
    use MooseX::StrictConstructor();

    sub import {
        my $class = shift;
        my %opts = @_;

        push @{ $opts{'imports'} ||= [] } => (
            'CairoX::Sweet::Types' => [{ replace => 1 }, '-types'],
            'MooseX::StrictConstructor' => [],
        );

        $class->SUPER::import(%opts);
    }
}

1;
