#!/usr/bin/perl

use warnings;
use strict;

use lib '..';

use Data::Dumper;
use File::Path qw(make_path remove_tree);
use Test::More tests => 4;

use GoportisHotfolderProcessor;

my $timestamp = time;

my $hotfolder = '/tmp/hotfolder' . $timestamp;

make_path($hotfolder . '/tib/inbox/conf_foo');
make_path($hotfolder . '/zbmed/inbox/conf_bar');
make_path($hotfolder . '/zbmed/inbox/conf_blurp');

my @directories = GoportisHotfolderProcessor::get_directories(hotfolder => $hotfolder,);

is(scalar @directories, 3, 'get_directories must return 3 directories');
ok(grep {$_ eq $hotfolder . '/tib/inbox/conf_foo'} @directories, 'get_directories must get "/tmp/hotfolder/tib/inbox/conf_foo"');
ok(grep {$_ eq $hotfolder . '/zbmed/inbox/conf_bar'} @directories, 'get_directories must get "/tmp/hotfolder/zbmed/inbox/conf_bar"');
ok(grep {$_ eq $hotfolder . '/tib/inbox/conf_foo'} @directories, 'get_directories must get "/tmp/hotfolder/zbmed/inbox/conf_blurp"');

remove_tree($hotfolder);












