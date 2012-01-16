package Dist::Maker::Template::ModuleBuild::WithGit;
use Mouse;

extends 'Dist::Maker::Template::ModuleBuild';

sub dist_init {
    my($self, $meta) = @_;
    chdir $meta->{distdir} or return;

    eval {
        $self->run_command($^X, 'Build.PL');
        $self->run_command($^X, 'Build', 'manifest');
        $self->run_command('git', '--init');
        $self->run_command('git', 'add', '.');
        $self->run_command('git', 'commit', '-m', 'initial commit');
    };
    chdir '..';
    die $@ if $@;
    return;
}

1;
