# run perl script ospf2dot

use strict;
use warnings;
use File::Slurp qw(slurp);
use File::Temp;
use Test::More tests => 2 + 4;

my %tmpargs = (
    SUFFIX => ".dot",
    TEMPLATE => "ospfview-script-ospf2dot-XXXXXXXXXX",
    TMPDIR => 1,
    UNLINK => 1,
);

my $tmp = File::Temp->new(%tmpargs);

my @incs = map { ('-I', $_) } @INC;
my @cmd = ('perl', @incs, "script/ospf2dot", "-cBSE",
    "example/all.yaml", $tmp->filename);
system(@cmd);
is($?, 0, "exit") or diag("Command '@cmd' failed: $?");

is(slurp($tmp), slurp("example/all.dot"), "output") or do {
    diag("example/all.yaml not converted to example/all.dot");
    system('diff', '-up', "example/all.dot", $tmp->filename);
};

@cmd = ('perl', @incs, "script/ospf2dot");
foreach my $opt (qw(b e s w)) {
    my $options = '-'.lc($opt).uc($opt);
    my $pid = fork();
    defined($pid) or die "Fork failed: $!";
    if (!$pid) {
	# child
	open(STDERR, '>', "/dev/null")
	    or die "Redirect stderr to /dev/null failed: $!";
	push @cmd, $options, "/dev/null";
	exec(@cmd);
	die "Exec '@cmd' failed: $!";
    }
    wait() or die "Wait failed: $!";
    is($?, 2<<8, "option $opt")
	or diag("Options $options may not be used together");
}
