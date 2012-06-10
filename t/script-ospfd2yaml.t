# run perl script ospfd2yaml

use strict;
use warnings;
use File::Slurp qw(slurp);
use File::Temp;
use Test::More tests => 2;

my %tmpargs = (
    SUFFIX => ".yaml",
    TEMPLATE => "ospfview-script-ospfd2yaml-XXXXXXXXXX",
    TMPDIR => 1,
    UNLINK => 1,
);

my $tmp = File::Temp->new(%tmpargs);

my @incs = map { ('-I', $_) } @INC;
my @cmd = ('perl', @incs, "script/ospfd2yaml",
    '-B', "example/ospfd.boundary",
    '-E', "example/ospfd.external",
    '-I', "example/ospfd.selfid",
    '-N', "example/ospfd.network",
    '-R', "example/ospfd.router",
    '-S', "example/ospfd.summary",
    $tmp->filename);
system(@cmd);
is($?, 0, "exit") or diag("Command '@cmd' failed: $?");

@cmd = ('perl', @incs, "script/ospfd2yaml",
    '-6',
    '-B', "example/ospf6d.boundary",
    '-E', "example/ospf6d.external",
    '-I', "example/ospf6d.selfid",
    '-L', "example/ospf6d.link",
    '-N', "example/ospf6d.network",
    '-P', "example/ospf6d.intra",
    '-R', "example/ospf6d.router",
    '-S', "example/ospf6d.summary",
    $tmp->filename);
system(@cmd);
is($?, 0, "exit 6") or diag("Command '@cmd' failed: $?");
