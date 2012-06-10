# perl syntax check for all library modules

use strict;
use warnings;
use Test::More;

my @libs = qw(
    OSPF::LSDB
    OSPF::LSDB::Cisco
    OSPF::LSDB::View
    OSPF::LSDB::View6
    OSPF::LSDB::YAML
    OSPF::LSDB::gated
    OSPF::LSDB::ospfd
    OSPF::LSDB::ospf6d
);

plan tests => scalar @libs;

foreach (@libs) {
    use_ok($_);
}
