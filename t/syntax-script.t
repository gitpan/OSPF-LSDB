# perl syntax check for all scripts

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

plan tests => scalar @scripts;

foreach (@scripts) {
    my @incs = map { ('-I', $_) } @INC;
    my @cmd = ('perl', @incs, '-c', "script/$_");
    system(@cmd);
    is($?, 0, $_) or diag("Command '@cmd' failed: $?");
}
