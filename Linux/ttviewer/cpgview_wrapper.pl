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
my $data_prep  = $Bin."/data_process.py";

my $cmd        = "(cd $outdir; $python $data_prep $inputfile1 dc dt dr)";
print STDERR "$cmd\n"; `$cmd`;

my $of_c_pdf  = $projectid."_cis.pdf";
my $cmd = "(cd $Bin; Rscript viewCSGene.R $outdir/dc/cis_splicing_gene.csv $outdir/dc/cis_splicing_subgene.csv $outdir/$of_c_pdf)";
print STDERR "$cmd\n"; `$cmd`;

my $of_t_pdf  = $projectid."_trans.pdf";
my $cmd = "(cd $Bin; Rscript viewTSGene.R $outdir/dt/trans_splicing_gene.csv $outdir/dt/trans_splicing_subgene.csv $outdir/$of_t_pdf)";
print STDERR "$cmd\n"; `$cmd`;

###convert pdf to png for the _c file
my $of_c_png = $projectid."_cis.png";
my $cmd      = "/biodata4/home/cliu/cpgview/bin/python $Bin/pdf2img.py $outdir/$of_c_pdf $outdir";
print STDERR "$cmd\n"; `$cmd`;

my $cmd      = "mv $outdir/images_0.png $outdir/$of_c_png";
print STDERR "$cmd\n"; `$cmd`;

###convert pdf to png for the _t file
my $of_t_png = $projectid."_trans.png";
my $cmd      = "/biodata4/home/cliu/cpgview/bin/python $Bin/pdf2img.py $outdir/$of_t_pdf $outdir";
print STDERR "$cmd\n"; `$cmd`;

my $cmd      = "mv $outdir/images_0.png $outdir/$of_t_png";
print STDERR "$cmd\n"; `$cmd`;


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


