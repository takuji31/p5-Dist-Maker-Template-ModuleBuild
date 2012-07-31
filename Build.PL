use strict;
use warnings;
use Module::Build;

my $buiild = Module::Build->new(
    dist_author => 'takuji@senchan.jp <takuji@senchan.jp>',
    dist_abstract => 'Dist-Maker-Template-ModuleBuild',
    license     => 'perl',
    module_name => 'Dist::Maker::Template::ModuleBuild',
    configure_requires => {'Module::Build' => '0.38'},
    requires => {
        'Dist::Maker' => '0.05',
    },
    build_requires => {
        'Test::More'                 => '0.98',
    },
    test_files => -d 'xt/' ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme => 1,
    create_license => 1,
    create_makefile_pl => 'small',
);
$buiild->create_build_script();
