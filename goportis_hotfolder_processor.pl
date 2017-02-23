#!/usr/bin/perl

use warnings;
use strict;

use GoportisHotfolderProcessor;

my @full_file_names = GoportisHotfolderProcessor::rename_pdfs(hotfolder_inbox => $ENV{"HOME"} . '/hotfolder/inbox', suffix => 'processing',);

# renamed file names
my @successful_file_names = GoportisHotfolderProcessor::convert_pdfs(full_file_names => \@full_file_names,);















