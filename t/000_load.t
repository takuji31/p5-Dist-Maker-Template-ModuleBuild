#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Dist::Maker::Template::ModuleBuild';
}

diag "Testing Dist::Maker::Template::ModuleBuild/$Dist::Maker::Template::ModuleBuild::VERSION";
