# perl syntax check for pod files

use strict;
use warnings;
use Test::More;
use Pod::Checker;

my @pods;
push @pods, map { "doc/$_.pod" } qw(
    ciscoospf2yaml
    ospf2dot
    ospfd2yaml
    gated2yaml
    ospfconvert
    ospfview
);
push @pods, map { local $_ = $_; s,::,/,g; "lib/$_.pm" } qw(
    OSPF::LSDB
    OSPF::LSDB::Cisco
    OSPF::LSDB::View
    OSPF::LSDB::View6
    OSPF::LSDB::YAML
    OSPF::LSDB::gated
    OSPF::LSDB::ospfd
    OSPF::LSDB::ospf6d
);
plan tests => 2 * scalar @pods;

foreach (@pods) {
    my $checker = Pod::Checker->new(-warnings => 1);
    $checker->parse_from_file($_, \*STDERR);
    my $err = $checker->num_errors();
    is($err, 0, "$_ error") or diag("Found $err POD errors in $_");
    my $warn = $checker->num_warnings();
    is($warn, 0, "$_ warning") or diag("Found $warn POD warnings in $_");
}
