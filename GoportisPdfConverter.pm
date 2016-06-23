package GoportisPdfConverter;

use warnings;
use strict;

# Read hotfolder recursively into datastructure, but only directories.
# The files will be read once its directory is being processed.
# Returns an array of full paths

sub get_directories {
	my %args = @_;
	my $hotfolder = $args{hotfolder} || die('hotfolder missing');
	
	my @directories;
	
	
	
	# do the trick
	
	return @directories;
}

# Rename pdf files so that the word 'processing' is appended as a suffix
# E.g introduction.pdf => introduction.pdf.processing

sub rename_pdfs {
	my %args = @_;
	my $directories_aref = $args{directories} || die('directories missing');
	my $suffix           = $args{suffix}      || 'processing';
	
	my @full_file_names;
	
	# do the trick
	
	return @full_file_names;
}

# Convert the pdf files by calling pdfapilot on the file names
# file names contain '.processing' as a suffix
	
sub convert_pdfs {
	my %args = @_;
	my $full_file_names = $args{full_file_names} || eh('full_file_names missing'); # an arrayref of paths
	
	# check whether the config file exists
	
	# call pdfapilot with the config file on each full file name
	
	# on success remove the pdf file in the inbox directory
	# on failure: tbd
	
	return;
}

















