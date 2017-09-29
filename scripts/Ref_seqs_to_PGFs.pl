#! /usr/bin/env perl
use strict;
use Getopt::Long;


my $usage = 'Ref_seqs_to_PGFs.pl [options] >PGFs       
  
  This program will take a protien fasta file or a directory 
  of protein fasta files and compute the PATRIC global families 
  for each protein.  You must be in the home directories to run 
  this because it makes a system call to "place_proteins_into_pattyfams",
  which is not currently an external script.       
    
    options:
    	-h help
    	-d directory of fasta files (multiple files as input)
    	    NOTE: It is assumed that all fasta headers are unique.
    	    NOTE: No other file type is allowed in the fasta directory.
    	-f fasta file (single file as input)
    	-k k-mer directory for pattyfam lookup d= /vol/patric3/fams/2017-0701/kmers
    	    NOTE: This directory eventually become outdated.
    	-u url for place_proteins into pattyfams d = http://spruce:6100, 
    	    NOTE: This may also change.
    	   

            ';

my $help;
my $url = 'http://spruce:6100';
my $kmers = '/vol/patric3/fams/2017-0701/kmers';
my ($file, $dir, $out);

my $opts = GetOptions( 'h'   => \$help,
                       'd=s' => \$dir,
                       'f=s' => \$file,
                       'k=s' => \$kmers,
                       'u=s'  => \$url);

if ($help){die "$usage\n";}
if (($file) && ($dir)){die "must declare -f file, or -d dir, not both.\n";}
if ((! $file) && (! $dir)){die "must declare either -f file, or -d dir.\n";}



if ($file)
{
	system "place_proteins_into_pattyfams $kmers $url $file";
}

else
{
	opendir (DIR, "$dir") or die "cannot open fasta directory\n";
	my @fastas = grep {$_ !~ /^\./}readdir(DIR);
	close DIR;
	foreach (@fastas)
	{	
		print "$_\n";
		system "place_proteins_into_pattyfams $kmers $url $dir/$_";
	}
}


































