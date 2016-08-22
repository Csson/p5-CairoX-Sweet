use 5.10.0;
use strict;
use warnings;

package CairoX::Sweet::Elk;

# AUTHORITY
# ABSTRACT: Internal Moose
our $VERSION = '0.0201';

use Moose();
use MooseX::AttributeShortcuts();
use namespace::autoclean();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(also => ['Moose']);

sub init_meta {
    my $class = shift;

    my %params = @_;
    my $for_class = $params{'for_class'};
    Moose->init_meta(@_);
    MooseX::AttributeShortcuts->init_meta(for_class => $for_class);
    namespace::autoclean->import(-cleanee => $for_class);
}

1;
