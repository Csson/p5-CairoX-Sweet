use CairoX::Sweet::Standard;

# PODNAME: CairoX::Sweet::Role::PathCommand

role CairoX::Sweet::Role::PathCommand using Moose {
    requires 'location', 'move_location';
}
