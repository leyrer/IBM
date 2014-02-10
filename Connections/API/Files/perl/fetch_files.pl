#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::FeedPP;
use List::MoreUtils qw(part);
use URI::Escape;
use threads;
use threads::shared;

BEGIN { $| = 1 }

my $REALM = 'lotus-connections'; # the default realm for Connections is 'lotus-connections'
my $MAXFILES = '500';			 # Maximum number of files per page. 500 is the hard limit in Connections
my $USE_THREADS = 0;			 # set to 1 if you want to split the downloads into 10 parallel threads

## Parse options and print usage if there is a syntax error,
## or if usage was explicitly requested.
our $opt_server = ''; our $opt_username = ''; our $opt_password = '';
our $opt_workdir= '.'; our $opt_help = ''; our $opt_man= '';
GetOptions( "server=s", "username=s", "password=s", "workdir=s", "help", "man",
			) or pod2usage(2);
pod2usage(1) if $opt_help;
pod2usage(-verbose => 2) if $opt_man;

#base url for the connections file download
# TODO: get the file from the Files service document instead of hardcoding it here.
# See http://www-10.lotus.com/ldd/appdevwiki.nsf/xpDocViewer.xsp?lookupName=IBM+Connections+4.5+API+Documentation#action=openDocument&res_title=Retrieving_the_Files_service_document_ic45&content=pdcontent for details
my $filesurl = 'https://' . $opt_server . '/files/basic/anonymous/api/documents/feed?sK=created&sO=dsc&visibility=public&pageSize=' . $MAXFILES;


print "Initiate connection to the Connections server ...\n";
my $connectionsUA = connect2Connection($opt_username, $opt_password, $opt_server, $REALM);

print "Fetching URLs to files ...\n";
my @filelist = &generateURLList($filesurl);
print 1+$#filelist . " files to fetch.\n\n";

if( $USE_THREADS ) {	#  parallelize downloads
	my $i;

	# split the list of files to download into 10 parts
	my @splitfilelists = part { 10 * $i++ / @filelist} @filelist;

	# start 10 threads with the corresponding download-list
	my $sflc = 1;
	foreach my $sfl (@splitfilelists) {
		my $thr = async {	{'void' => 1},
							\&fetchFilesThreads($sflc, @{$sfl}); 
						};
		$sflc++;
	}

	#wait for all threads to finish
	my @threadlist;
	do {
		sleep(2);
		my @threadlist = threads->list(threads::running);
		#print "Threads running:";
		#print 1 + $#threadlist . "\n";
		# print Dumper (threads->list(threads::running)) . "\n";
	} until($#threadlist == 0);

} else {	# serialized download in one thread
	&fetchFilesThreads(1, @filelist);
}

print "DONE!\n";
exit;


# wraper function to be called for each thread with a thread number and a list of files to download
sub fetchFilesThreads {
	my ($threadnr, @list) = @_;

	my $c = 1;
	foreach my $fn (@list) {
		print "Working on file #$threadnr/$c\n";
		&fetchFile($connectionsUA, $fn, "$threadnr/$c");
		$c++;
	}
}

# dowload the file from the url given and store in the file system
sub fetchFile {
	my($ua, $url, $nr) = @_;

	my $req = HTTP::Request->new( GET => $url );
	my $res = $ua->request($req);

	# Check the outcome of the response
	if( not $res->is_success ) {
    	print "Couldn't get file '$url'. Request/Response info:\n";
		print "~"x80 . "\n";
		print $req->as_string . "\n";
		print "-"x80 . "\n";
		# TODO parse the returned json, if there is any
		print $res->decoded_content;	# just dump the response
		print "\n";
    	die "Error getting file: " . $res->status_line, "\n";
	} 

	# print "\t" . $res->header('Content-Disposition') .  "\n";
	my $wf = &gen_filename( $res->header('Content-Disposition') );
	print "\t$nr - writing $wf\n";
	my $fn = $opt_workdir . "/" . $wf;
	if( not -e $fn ) {
		&write_file($fn, $res->content);
	} else {
		$res->header('Content-Disposition') =~ /size.*?=(\d+)/i;
		my $ds = $1; my $ls = -s "work/$wf";
		if(not -s $fn == $ds) {
			print "\tFilesize differs. local: $ls remote: $ds. Replacing existing file.\n";
			unlink($fn);
			&write_file($fn, $res->content);
		} else {
			print "\talready exists.\n";
		}
	}
}

sub gen_filename {
	my ($headercontent) = @_;
	$headercontent =~ /filename.*?=.*'(.*?);/i;
	my $wf = $1;
	$wf = uri_unescape($wf);
	return($wf);
}

sub write_file {
	my ($fn, $content) = @_;
	open(OUT, ">", $fn) or die "Schreibfehler $fn: $!\n";
	print OUT $content;
	close(OUT);
}

# fetch subsequent pages of the file list of public documents
# and store the found document list in an array
# the pages are in ATOM format
sub generateURLList {
	my($fileurl ) = @_;

	my $fetchnextpage = 1;
	my @filelist;
	
	while($fetchnextpage) {
		my $u = $fileurl . "&page=$fetchnextpage";

		print "\tfetching page $fetchnextpage ... ";
		my $atom = fetchPublicFileFeed($u);

		my $count = &getURLS($atom, \@filelist);
		print $count . " items found.\n";
		if( $count > 0 ) {
			$fetchnextpage++;
		} else {
			$fetchnextpage = 0;
		}
	}
	return(@filelist);
}

# parse a single ATOM page for document links
sub getURLS {
	my ($atom, $urls) = @_;

	my $feed = XML::FeedPP->new( $atom );
	my @itemlist = $feed->get_item();

	if( $#itemlist < 0) {
		return(0);
	} else {
		foreach my $item ( @itemlist ) {
		# print  Dumper($item->{content}->{'-src'});
# 'link' => [
#	{
#		'-hreflang' => 'en',
#		'-length' => '12753333',
#		'-title' => 'ID400.pdf',
#		'-type' => 'application/pdf',
#		'#text' => '',
#		'-rel' => 'enclosure',
#		'-href' => 'https://connections.connect2014.com/files/basic/...4357a6470166/media/ID400.pdf'
#	},
			my $a = $item->{link};
			foreach my $t (@$a) {
				if($t->{'-rel'} eq 'enclosure') {
					my $n = $t->{'-title'};
					my $s = $t->{'-length'};
					if( (-e "work/$n") and (-s "work/$n" == $s)) {
						;
					} else {
						push(@$urls, $t->{'-href'} );
					}
				}
			}
		}
		return(1+$#itemlist);
	}
}

# fetch one ATOM page containing a list of public documents
sub fetchPublicFileFeed {
	my ($file) = @_;

	my $req = HTTP::Request->new( GET => $file );
	my $res = $connectionsUA->request($req);

	# Check the outcome of the response
	if( not $res->is_success ) {
    	print "Couldn't get file '$file'. Request/Response info:\n";
		print "~"x80 . "\n";
		print $req->as_string . "\n";
		print "-"x80 . "\n";
		# TODO parse the returned data (json?), if there is any
		print $res->decoded_content;	# just dump the response
		print "\n";
    	die "Error getting file '$file' " . $res->status_line, "\n";
	}
	return($res->decoded_content);
}


# Create UserAgent Object
sub connect2Connection {
	my($usr, $pwd, $srv, $realm) = @_;
	my $port = "443";


	if ( $usr eq '' ) {
		pod2usage( -verbose => 2, -message => "$0: Please state the IBM Connections username!\n");
		exit;
	}
	if ( $pwd eq '' ) {
		pod2usage( -verbose => 2, -message => "$0: Please state the IBM Connections password!\n");
		exit;
	}
	if ( $srv eq '' ) { 
		pod2usage( -verbose => 2, -message => "$0: Please state the IBM Connections servername!\n" );
		exit;
	}

	my $ua = LWP::UserAgent->new (
			agent => "file4Connections",
	);

	$ua->credentials( $srv . ':' . $port, $realm, $usr, $pwd );
	push @{ $ua->requests_redirectable }, 'POST';

	return $ua;
}


__END__

=head1 NAME

fetch_files.pl - Download all public files from a IBM Connections instance

=head1 SYNOPSIS

fetch_files.pl [-help|man] -user connections_username -password connections_password 
-server connections_server -workdir dirname

=head1 USAGE

perl fetch_files.pl -server connections.example.com -user username@example.com -password secrethaX0rPass0rd -workdir /home/username/Downloads

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-man>

Prints the manual page and exits.

=item B<-user>

The name of the connections user to login with.

=item B<-password>

The IBM Connections password for the user.

=item B<-server>

The servername (DNS hostname) ot the IBM Connections installation the files should be downloaded from.

=item B<-workdir>

The direktory, the files shoudl be saved into.

=back

=head1 DESCRIPTION

B<fetch_files> will download all public files from a Connections server using Connections API and saves those files to the given directory. Exisiting files will be overwriten if they differ in size from the files inside Connections.

A handy tool to download for example all presentations of the IBM Connect 2014 conference.

=head1 NOTABLE INFO

=over 8

=head1 Versions

This code has been tested with Connection 4.5 and perl 5, version 12, subversion 4 (v5.12.4) built for i686-linux-gnu-thread-multi-64int.

=head1 Installing required libraries on Ubuntu

sudo aptitude install libxml-feedpp-perl

=head1 Licence

Code made available under the Apache 2.0 license. http://www.apache.org/licenses/example-NOTICE.txt

=head1 Authors

Martin Leyrer -- leyrer+connections@gmail.com

=cut

