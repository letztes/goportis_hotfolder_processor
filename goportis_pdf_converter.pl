#!/usr/bin/perl

use warnings;
use strict;

use GoportisPdfConverter;

my $hotfolder = '/home/artur/Schreibtisch/hotfolder'

my @directories = GoportisPdfConverter::get_directories(hotfolder => $hotfolder,);

my @full_file_names = GoportisPdfConverter::rename_pdfs(directories => \@directories, suffix => 'processing',);

my @successful_file_names = GoportisPdfConverter::convert_pdfs(full_file_names => \@full_file_names,);















