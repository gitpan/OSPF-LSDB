# run perl script ospfconvert

use strict;
use warnings;
use File::Slurp qw(slurp);
use File::Temp;
use Test::More tests => 2;

my %tmpargs = (
    SUFFIX => ".yaml",
    TEMPLATE => "ospfview-script-ospfconvert-XXXXXXXXXX",
    TMPDIR => 1,
    UNLINK => 1,
);

my $tmp = File::Temp->new(%tmpargs);

my @incs = map { ('-I', $_) } @INC;
my @cmd = ('perl', @incs, "script/ospfconvert",
    "example/old.yaml", $tmp->filename);
system(@cmd);
is($?, 0, "exit") or diag("Command '@cmd' failed: $?");

is(slurp($tmp), slurp("example/all.yaml"), "output") or do {
    diag("example/old.yaml not converted to example/all.yaml");
    system('diff', '-up', "example/all.yaml", $tmp->filename);
};
