requires 'perl', '5.010001';

requires 'Moose', '2.0000';
requires 'Moops';
requires 'MooseX::StrictConstructor';
requires 'List::AllUtils';
requires 'Eponymous::Hash';
requires 'Path::Tiny';
requires 'Type::Tiny';
requires 'Types::Standard';
requires 'Types::TypeTiny';
requires 'Cairo';
requires 'Types::Path::Tiny';

on test => sub {
	requires 'Test::More', '0.96';
};
