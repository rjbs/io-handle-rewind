#!perl

use strict;
use warnings;

use ICG::Handy qw(readfile writefile);
use Test::More 'no_plan';
use IO::File;

use_ok("IO::Rewind");

my $out = "./t/rewind.out";

writefile($out, "a\nb\n");

my $fh = IO::File->new($out, 'r');

is(<$fh>, "a\n", 'first line matches');

my $re = IO::Rewind->new($fh);
isa_ok($re, 'IO::Rewind', 'created rewind object');

$re->rewind("a\n");
is($re->getline, "a\n", 'got rewound line');

$re->rewind(["z\n", "y\n", "x\n"]);
is($re->getline, "z\n", "got rewound line from arrayref");

is_deeply(
  [ $re->getlines ],
  [ "y\n", "x\n", "b\n" ],
  "got all rewound and regular lines from getlines",
);

is($re->readline, undef,
   'got undef after exhausting filehandle');
