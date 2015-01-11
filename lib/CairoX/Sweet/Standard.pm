use 5.20.0;

# VERSION

package CairoX::Sweet::Standard {

    use base 'Moops';
    use Types::CairoX::Sweet();
    use MooseX::StrictConstructor();
    use List::AllUtils();
    use Path::Tiny();

    sub import {
        my $class = shift;
        my %opts = @_;

        push @{ $opts{'imports'} ||= [] } => (
            'Types::CairoX::Sweet' => [{ replace => 1 }, '-types'],
            'MooseX::StrictConstructor' => [],
            'List::AllUtils' => [qw/any sum zip/],
            'Path::Tiny' => ['path'],
        );

        $class->SUPER::import(%opts);
    }
}

1;
