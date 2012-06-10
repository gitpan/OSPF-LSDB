# check usage for all perl scripts

use strict;
use warnings;
use Test::More;

my @scripts = qw(
    ciscoospf2yaml
    gated2yaml
    ospf2dot
    ospfconvert
    ospfd2yaml
    ospfview
);

plan tests => 2 * scalar @scripts;

foreach (@scripts) {
    my @incs = map { ('-I', $_) } @INC;
    my @cmd = ('perl', @incs, "script/$_", '-h');
    my $pid = open(my $fh, '-|');
    defined($pid) or die "Fork and open pipe failed: $!";
    if (!$pid) {
	# child
	open(STDERR, '>&', \*STDOUT) or die "Dup stdout to stderr failed: $!";
	exec(@cmd);
	die "Exec '@cmd' failed: $!";
    }
    my $out = eval { local $/; <$fh> };
    close($fh) || !$! or die "Fork and open pipe failed: $!";
    is($?, 2<<8, "$_ exit") or diag("Command '@cmd' exit code is not 2<<8: $?");
    like($out, qr{^Usage: script/$_ }m, "$_ usage") or diag("No usage: $out");
}
