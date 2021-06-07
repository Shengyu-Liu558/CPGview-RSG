#!/usr/bin/perl
#
use FindBin qw($Bin);

my $inputfile = shift;
my $projectid = shift;
my $outdir    = shift;

print STDERR "$Bin $inputfile $projectid $outdir\n";

if (! -e $inputfile || $outdir eq "") {
	print STDERR "\ninputfile does not exist\n\nUsage: $0 inputfile projectid outdir\n\n";
	exit;
}

if ($projectid eq "") {
	$projectid = time();
	$projectid =~ s/\s+//g;
}

#$outdir = "/var/www/html/upload/d".$projectid;
#my $outdir = "/tmp/d".$projectid;
my $inputfile1 = $projectid.".gbf";

my $cmd = "mkdir $outdir";

`$cmd` unless (-e $outdir);
`cp $inputfile $outdir/$inputfile1`;

my $python     = "/biodata4/home/cliu/cpgview/bin/python";

my $of_cc_pdf = $projectid."_circle0";
my $cmd = "(cd $Bin/Chloroplot/; Rscript chloroplot_Genes.R $outdir/$inputfile1 $outdir/$of_cc_pdf)";
print STDERR "$cmd\n"; `$cmd`;




my $addword  = $Bin."/addtext.py";
my $cmd = "(cd $outdir; $python $addword $inputfile1 $projectid $outdir)";
print STDERR "$cmd\n"; `$cmd`;

my $out_circle = $outdir."/".$projectid."_circle0.pdf";
my $cmd = unlink("$out_circle");

my $of_cc_png = $projectid."_circle.png";
my $fin_circle = $projectid."_circle.pdf";

my $cmd = "/biodata4/home/cliu/cpgview/bin/python $Bin/pdf2img.py $outdir/$fin_circle $outdir";
print STDERR "$cmd\n"; `$cmd`;

my $cmd      = "mv $outdir/images_0.png $outdir/$of_cc_png";
print STDERR "$cmd\n"; `$cmd`;


