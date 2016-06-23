#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use GoportisHotfolderProcessor;

my $hotfolder = '/var/pdfaPilot/hotfolder';

my @directories = GoportisHotfolderProcessor::get_directories(hotfolder => $hotfolder,);

my @full_file_names = GoportisHotfolderProcessor::rename_pdfs(directories => \@directories, suffix => 'processing',);

my $result = GoportisHotfolderProcessor::convert_pdfs(full_file_names => \@full_file_names,);















