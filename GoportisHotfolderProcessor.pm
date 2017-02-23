package GoportisHotfolderProcessor;

use warnings;
use strict;

use File::Basename;
use File::Path qw(make_path);

=pod

=head2 get_directories

Read hotfolder recursively into datastructure, but only directories.
The files will be read once its directory is being processed.
Returns an array of absolute paths.

=cut

sub get_directories {
	my %args = @_;
	my $hotfolder = $args{hotfolder} || die('hotfolder missing');
	
	my @directories;
	
	opendir(my $hotfolder_dh, $hotfolder) or die $!;
	while(my $institution = readdir $hotfolder_dh) {
		next if ($institution eq '.' or $institution eq '..');
		
		opendir(my $inbox_dh, "$hotfolder/$institution/inbox") or die $!;
		
		while(my $conf = readdir $inbox_dh) {
			next if ($conf eq '.' or $conf eq '..');

			push @directories, "$hotfolder/$institution/inbox/$conf";
		}
		closedir $inbox_dh;
	}
	closedir $hotfolder_dh;
	
	return @directories;
}

=pod

=head2

Rename pdf files so that the word 'processing' is appended as a suffix
E.g introduction.pdf => introduction.pdf.processing

=cut

sub rename_pdfs {
        my %args = @_;
        my $hotfolder_inbox  = $args{hotfolder_inbox} || die('hotfolder_inbox missing');
        my $suffix           = $args{suffix}          || 'processing';

        my @full_file_names;

		opendir (my $dh, $hotfolder_inbox) or die $!;
		while (my $pdf_file = readdir $dh) {

				#skip everything but pdf
				next if $pdf_file !~ /.pdf$/;
				rename("$hotfolder_inbox/$pdf_file", "$hotfolder_inbox/$pdf_file.$suffix") or die $!;
				push @full_file_names, "$hotfolder_inbox/$pdf_file.$suffix";
		}

        return @full_file_names;
}


=pod

=head2 convert_pdfs

Convert the pdf files by calling pdfapilot on the file names.
File names to read contain '.processing' as a suffix, file names
to write do not.
Reports are written to ~/pdfaPilot_reports/.
Output of pdfaPilot script is written to /tmp/pdfaPilot_log.

=cut
	
sub convert_pdfs {
        my %args = @_;
        my $full_file_names_aref = $args{full_file_names} || die('full_file_names missing'); # an arrayref of paths
        my @full_file_names = @{$full_file_names_aref};
        
        my @successful_file_names; # with the temporary file name suffix
        
        # call pdfapilot with the config file on each full file name
        foreach my $full_file_name (@full_file_names) {
        
                my ($inbox_file_name, $inbox_dir, $suffix) = fileparse($full_file_name, '.pdf.processing');
        
                my $outbox_file_name = quotemeta($inbox_file_name) . $suffix;
                my $quoted_full_file_name = $inbox_dir . $outbox_file_name;
                $outbox_file_name =~ s/.processing$//i;
        
                my $outbox_dir = $inbox_dir;
                $outbox_dir =~ s/inbox/outbox/i;
        
                my $response_file_parameter = '';
                if (-f $inbox_dir . 'config.rsp') {
                        $response_file_parameter = '@' . $inbox_dir . 'config.rsp';
                }

                my $error_list;
                make_path($outbox_dir, {error => \$error_list});
                die "error with $outbox_dir" if $error_list and scalar @$error_list;
        
                make_path($ENV{"HOME"} . '/pdfaPilot_reports', {error => \$error_list});
                die 'error with ' . $ENV{"HOME"} . '/pdfaPilot_reports' if $error_list and scalar @$error_list;

                qx(date >> \$HOME/pdfaPilot_log; \$HOME/pdfapilot/pdfaPilot $response_file_parameter --cachefolder=\$HOME --report=PATH=\$HOME/pdfaPilot_reports/$outbox_file_name.html --outputfile=$outbox_dir$outbox_file_name $quoted_full_file_name >> \$HOME/pdfaPilot_log 2>&1);

				# $? contains the return value, usually text.
				# shifted by 8 bytes one can get the exit status.
				# exit status 0 is good, everything else is bad.
				if (not $? >> 8) {
					push @successful_file_names, $full_file_name;
				}
				
                unlink($full_file_name) or die $!; 
        
        }
        
        return @successful_file_names;
}



















1;
