requires 'perl', '5.014000';

requires 'MooseX::StrictConstructor';
requires 'List::AllUtils';
requires 'Eponymous::Hash';
requires 'Moose', '2.0000';
requires 'Moops';
requires 'Path::Tiny';
requires 'Type::Tiny', '1.000000';
requires 'Types::Path::Tiny';
requires 'Cairo', '1.000';

on test => sub {
	requires 'Test::More', '0.96';
};
