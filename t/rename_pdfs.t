#!/usr/bin/perl

use warnings;
use strict;

use lib '..';

use File::Path qw(make_path remove_tree);
use Test::More tests => 4;

use GoportisHotfolderProcessor;

my $timestamp = time;

my $hotfolder = '/tmp/hotfolder' . $timestamp;

make_path($hotfolder . '/tib/inbox/conf_foo');
{
	open(my $fh, '>', $hotfolder . '/tib/inbox/conf_foo/file1.pdf');
	close $fh;
}
make_path($hotfolder . '/zbmed/inbox/conf_bar');
{
	open(my $fh, '>', $hotfolder . '/zbmed/inbox/conf_bar/file1.pdf');
	close $fh;
}

make_path($hotfolder . '/zbmed/inbox/conf_blurp');
{
	open(my $fh, '>', $hotfolder . '/zbmed/inbox/conf_blurp/file1.pdf');
	close $fh;
}

my @directories = (
	$hotfolder . '/tib/inbox/conf_foo',
	$hotfolder . '/zbmed/inbox/conf_bar',
	$hotfolder . '/zbmed/inbox/conf_blurp',
);

my @full_file_names = GoportisHotfolderProcessor::rename_pdfs(directories => \@directories, suffix => 'processing',);

is(scalar @full_file_names, 3, 'get_directories must return 3 directories');
ok(grep {$_ eq $hotfolder . '/tib/inbox/conf_foo/file1.pdf.processing'} @full_file_names, 'rename_pdfs must get "/tmp/hotfolder/tib/inbox/conf_foo/file1.pdf.processing"');
ok(grep {$_ eq $hotfolder . '/zbmed/inbox/conf_bar/file1.pdf.processing'} @full_file_names, 'rename_pdfs must get "/tmp/hotfolder/zbmed/inbox/conf_bar/file1.pdf.processing"');
ok(grep {$_ eq $hotfolder . '/zbmed/inbox/conf_blurp/file1.pdf.processing'} @full_file_names, 'rename_pdfs must get "/tmp/hotfolder/zbmed/inbox/conf_blurp/file1.pdf.processing"');

remove_tree($hotfolder);












