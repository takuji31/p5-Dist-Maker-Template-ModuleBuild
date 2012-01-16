package Dist::Maker::Template::ModuleBuild;
use utf8;
use Mouse;
use MouseX::StrictConstructor;

use Dist::Maker::Util qw(run_command);

our $VERSION = "0.01";

extends 'Dist::Maker::Base';
with    'Dist::Maker::Template';

sub dist_init {
    my($self, $meta) = @_;
    chdir $meta->{distdir} or return;

    eval {
        $self->run_command($^X, 'Build.PL');
        $self->run_command($^X, 'Build', 'manifest');
    };
    chdir '..';
    die $@ if $@;
    return;
}

sub distribution {
    # empty expression <: :> is used
    # in order to avoid to confuse PAUSE indexers
    return <<'DIST';
@@ Build.PL
use strict;
use warnings;
use Module::Build;

my $buiild = Module::Build->new(
    dist_author => '<: $user.email :> <<: $user.email :>>',
    dist_abstract => '<: $dist :>',
    license     => 'perl',
    module_name => '<: $dist.module :>',
    configure_requires => {'Module::Build' => '0.38'},
    requires => {
    },
    build_requires => {
        'Test::LoadAllModules'       => '0.021',
        'Test::More'                 => '0.98',
    },
    test_files => (-d '.git/' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme => 1,
    create_license => 1,
    create_makefile_pl => 'small',
);
$buiild->create_build_script();


@@ README

This is Perl module <: $dist.module :>.

INSTALLATION

Type the following command:

    $ curl -L http://cpanmin.us | perl - <: $dist.module :>

Or install cpanm and then run the following command to install
<: $dist.module :>:

    $ cpanm <: $dist.module :>

If you get an archive of this distribution, unpack it and build it
as per the usual:

    $ tar xzf <: $dist :>-$version.tar.gz
    $ cd <: $dist :>-$version
    $ perl Build.PL
    $ ./Build && ./Build test

Then install it:

    $ ./Build install

DOCUMENTATION

<: $dist.module :> documentation is available as in POD. So you can do:

    $ perldoc <: $dist.module :>

to read the documentation online with your favorite pager.

LICENSE AND COPYRIGHT

: copyright()

: license()

@@ Changes

Revision history for Perl extension <: $dist.module :>

NEXT <<SET RELEASE DATE HERE>>
    - original version; created by <: $software // 'Dist::Maker' :>
      at <: localtime() :>.

@@ .gitignore
<: $dist :>-*
.*
!.gitignore
!.shipit
!.dim.pl
inc/
*.o
*.obj
*.bs
*.def
Makefile*
!Makefile.PL
Build*
!Build.PL
*blib
META.*
MYMETA.*
*.out
*.bak
*.old
*~
*.swp
ppport.h
nytprof*
cover_db*
*.gcda
*.gcno
*.gcov
*.stackdump
_build/
: block gitignore { }
@@ .shipit
steps = FindVersion, ChangeAllVersions, CheckChangeLog, DistTest, Commit, Tag, MakeDist, UploadCPAN

git.tagpattern = %v
git.push_to = origin

CheckChangeLog.files = Changes

@@ MANIFEST.SKIP
#!include_default

# skip author's files
\bauthor\b

\.bs$
\.o(?:|bj|ld|ut)$
\.sw(?:p|o)
nytprof
.dim.pl
.shipit


: block manifest_skip { }
@@ lib/<: $dist.path :>.pm
package <: $dist.module :>;
use 5.008_001;
: block module_header -> {
use strict;
use warnings;
: }

our $<: :>VERSION = '<: $module.initial_version :>';

: block module_code -> { }

: block module_footer -> {
1;
: }
__END__

<: :>=head1 NAME

<: $dist.module :> - Perl extention to do something

=head1 VERSION

This document describes <: $dist.module :> version <: $module.initial_version :>.

=head1 SYNOPSIS

: block synopsis {
    use <: $dist.module :>;
: }

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.10.0 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

<: $user.name :> E<lt><: $user.email :>E<gt>

=head1 LICENSE AND COPYRIGHT

: block copyright -> {
Copyright (c) <: localtime().year :>, <: $user.name :>. All rights reserved.
: }

: block license -> {
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
: }

=cut

@@ t/000_load.t
use strict;
use Test::LoadAllModules;

BEGIN {
    all_uses_ok(
        search_path => "<: $dist.module :>",
        except => [],
    );
}


: block load_t_testing_info {
diag "Testing <: $dist.module :>/$<: $dist.module :>::VERSION";
: }
@@ t/001_basic.t
use strict;
use Test::More;

use <: $dist.module :>;

# test <: $dist.module :> here
: block basic_t_tests -> {
pass;
: }

done_testing;
@@ xt/pod.t
use strict;
use Test::More;
eval q{use Test::Pod 1.14};
plan skip_all => 'Test::Pod 1.14 required for testing POD'
    if $@;

all_pod_files_ok();

@@ xt/podspell.t
use strict;
use Test::More;

eval q{ use Test::Spelling };
plan skip_all => q{Test::Spelling is not available.}
    if $@;

my @stopwords;
while(my $line = <DATA>) {
    $line =~ s/ \# [^\n]+ //xms;
    push @stopwords, $line =~ /(\w+)/g;
}
add_stopwords(@stopwords);

$ENV{LC_ALL} = 'C';
all_pod_files_spelling_ok('lib');

__DATA__
<: $user.name :>
<: $user.email :>
<: $dist.module :>

# computer terms
API
APIs
arrayrefs
arity
Changelog
codebase
committer
committers
compat
cpan
extention
datetimes
dec
definedness
destructor
destructors
destructuring
dev
DWIM
GitHub
hashrefs
hotspots
immutabilize
immutabilizes
immutabilized
inline
inlines
invocant
invocant's
irc
IRC
isa
JSON
login
namespace
namespaced
namespaces
namespacing
OO
OOP
ORM
overridable
parameterizable
parameterization
parameterize
parameterized
parameterizes
params
pluggable
prechecking
prepends
rebase
rebased
rebasing
reblesses
refactored
refactoring
rethrows
RT
runtime
serializer
stacktrace
subclassable
subname
subtyping
TODO
unblessed
unexport
unimporting
Unported
unsets
unsettable
utils
whitelist
Whitelist
workflow
XS
MacOS
MacOSX
CLI
HTTP

versa # vice versa
ish   # something-ish
ness  # something-ness
pre   # pre-something
maint # co-maint

: block podcoverage_t {
@@ xt/podcoverage.t
use Test::More;
eval q{use Test::Pod::Coverage 1.04};
plan skip_all => 'Test::Pod::Coverage 1.04 required for testing POD coverage'
    if $@;

all_pod_coverage_ok({
    also_private => [qw(unimport BUILD DEMOLISH init_meta)],
});
: } # podcoverage_t

: block podsynopsis_t {
@@ xt/podsynopsis.t
use strict;
use Test::More;
eval q{use Test::Synopsis};
plan skip_all => 'Test::Synopsis required for testing SYNOPSIS'
    if $@;
all_synopsis_ok();
: } # podsynopsis_t

: block perlcritic_t {
@@ xt/perlcritic.t
use strict;
use Test::More;
eval q{
    use Perl::Critic 1.105;
    use Test::Perl::Critic -profile => \do { local $/; <DATA> };
};
plan skip_all => "Test::Perl::Critic is not available." if $@;
all_critic_ok('lib');
__DATA__

exclude=ProhibitStringyEval ProhibitExplicitReturnUndef RequireBarewordIncludes

[TestingAndDebugging::ProhibitNoStrict]
allow=refs

[TestingAndDebugging::RequireUseStrict]
: my $mooselike = [
:    "Mouse", "Mouse::Role", "Mouse::Exporter", "Mouse::Util",
:    "Mouse::Util::TypeConstraints",
:    "Moose", "Moose::Role", "Moose::Exporter",
:    "Moose::Util::TypeConstraints",
:    "Any::Moose"];
equivalent_modules = <: $mooselike.join(" ") :>

[TestingAndDebugging::RequireUseWarnings]
equivalent_modules = <: $mooselike.join(" ") :>
: } # perlcritic_t

@@ author/requires.cpanm
# for <: $dist :>
# Makefile.PL
: block author_requires_cpanm_configure_requires -> {
Module::Build
: }

# author's tests
: block author_requires_cpanm_test_requires -> {
Test::LoadAllModules
Test::Pod
Test::Pod::Coverage
Test::Spelling
Test::Perl::Critic
Test::Synopsis
: }

# Release tools
: block author_requires_cpanm_release_tools -> {
ShipIt
ShipIt::Step::ChangeAllVersions
CPAN::Uploader
: }

@@ EXTRA_FILES
: # hook spaces to add files
: block extra_files -> { }
DIST
}

no Mouse;
__PACKAGE__->meta->make_immutable();
__END__

=head1 NAME

Dist::Maker::Template::Default - The default distribution template

=cut
