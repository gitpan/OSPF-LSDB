# run perl script gated2yaml

use strict;
use warnings;
use File::Slurp qw(slurp);
use File::Temp;
use Test::More tests => 1;

my %tmpargs = (
    SUFFIX => ".yaml",
    TEMPLATE => "ospfview-script-gated2yaml-XXXXXXXXXX",
    TMPDIR => 1,
    UNLINK => 1,
);

my $tmp = File::Temp->new(%tmpargs);

my @incs = map { ('-I', $_) } @INC;
my @cmd = ('perl', @incs, "script/gated2yaml",
    '-D', "example/gated.dump", $tmp->filename);
system(@cmd);
is($?, 0, "exit") or diag("Command '@cmd' failed: $?");
