#!/usr/bin/perl

use warnings;
use strict;

use GoportisHotfolderProcessor;

my $hotfolder = '/var/pdfaPilot/hotfolder';

my @directories = GoportisHotfolderProcessor::get_directories(hotfolder => $hotfolder,);

my @full_file_names = GoportisHotfolderProcessor::rename_pdfs(directories => \@directories, suffix => 'processing',);

# renamed file names
my @successful_file_names = GoportisHotfolderProcessor::convert_pdfs(full_file_names => \@full_file_names,);















