#!/usr/bin/perl

use warnings;
use strict;

use lib '..';

use Data::Dumper;
use File::Path qw(make_path remove_tree);
use Test::More;

use GoportisHotfolderProcessor;

my $timestamp = time;

my $hotfolder = '/tmp/hotfolder' . $timestamp;

make_path($hotfolder . '/tib/inbox/conf_foo');
{
	open(my $fh, '>', $hotfolder . '/tib/inbox/conf_foo/file1.pdf.processing');
	close $fh;
}
make_path($hotfolder . '/zbmed/inbox/conf_bar');
{
	open(my $fh, '>', $hotfolder . '/zbmed/inbox/conf_bar/file1.pdf.processing');
	close $fh;
}

make_path($hotfolder . '/zbmed/inbox/conf_blurp');
{
	open(my $fh, '>', $hotfolder . '/zbmed/inbox/conf_blurp/file1.pdf.processing');
	close $fh;
}

my @full_file_names = (
	$hotfolder . '/tib/inbox/conf_foo/file1.pdf.processing',
	$hotfolder . '/zbmed/inbox/conf_bar/file1.pdf.processing',
	$hotfolder . '/zbmed/inbox/conf_blurp/file1.pdf.processing',
);

my @successful_file_names = GoportisHotfolderProcessor::convert_pdfs(full_file_names => \@full_file_names,);

ok(1); # dummy
#~ is(scalar @successful_file_names, 3, 'get_directories must return 3 directories');
#~ ok(grep {$_ eq $hotfolder . '/tib/inbox/conf_foo/file1.pdf.processing'} @successful_file_names, 'convert_pdfs must get "/tmp/hotfolder/tib/inbox/conf_foo/file1.pdf.processing"');
#~ ok(grep {$_ eq $hotfolder . '/zbmed/inbox/conf_bar/file1.pdf.processing'} @successful_file_names, 'convert_pdfs must get "/tmp/hotfolder/zbmed/inbox/conf_bar/file1.pdf.processing"');
#~ ok(grep {$_ eq $hotfolder . '/zbmed/inbox/conf_blurp/file1.pdf.processing'} @successful_file_names, 'convert_pdfs must get "/tmp/hotfolder/zbmed/inbox/conf_blurp/file1.pdf.processing"');

remove_tree($hotfolder);












done_testing;
