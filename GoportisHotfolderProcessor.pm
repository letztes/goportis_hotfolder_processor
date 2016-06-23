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
        my $directories_aref = $args{directories} || die('directories missing');
        my $suffix           = $args{suffix}      || 'processing';

        my @directories = @{$directories_aref};

        my @full_file_names;

        foreach my $directory (@directories) {
                opendir (my $dh, $directory) or die $!;
                while (my $pdf_file = readdir $dh) {
                        #must skip .rsp files too. better skip everything but pdf
                        #next if ($pdf_file eq '.' or $pdf_file eq '..');
                        next if $pdf_file !~ /.pdf$/;

                        rename("$directory/$pdf_file", "$directory/$pdf_file.$suffix");
                        push @full_file_names, "$directory/$pdf_file.$suffix";
                }
        }
        # do the trick

        return @full_file_names;
}


=pod

=head2 convert_pdfs

Convert the pdf files by calling pdfapilot on the file names.
File names to read contain '.processing' as a suffix, file names
to write do not.
Reports are written to /tmp/pdfaPilot_reports/.

=cut
	
sub convert_pdfs {
        my %args = @_;
        my $full_file_names_aref = $args{full_file_names} || die('full_file_names missing'); # an arrayref of paths
        my @full_file_names = @{$full_file_names_aref};
        
        # call pdfapilot with the config file on each full file name
        foreach my $full_file_name (@full_file_names) {
        
                my ($inbox_file_name, $inbox_dir, $suffix) = fileparse($full_file_name);
        
                my $outbox_file_name = $inbox_file_name;
                $outbox_file_name =~ s/.processing$//i;
        
                my $outbox_dir = $inbox_dir;
                $outbox_dir =~ s/inbox/outbox/i;
        
                my $response_file_parameter = '';
                if (-f $inbox_dir . 'config.rsp') {
                        $response_file_parameter = '@' . $inbox_dir . 'config.rsp';
                }
        
                make_path($outbox_dir);
                make_path('/tmp/pdfaPilot_reports/');
                qx(pdfaPilot $response_file_parameter --cachefolder=/tmp/ --report=PATH=/tmp/pdfaPilot_reports/$outbox_file_name.html --outputfile=$outbox_dir$outbox_file_name $full_file_name);
                        
                # if pdfaPilot returns numerical status values, add the successful
                # ones into an array to return
        
                unlink($full_file_name);
        
        }
        
        return;
}


















1;
