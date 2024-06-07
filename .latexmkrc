$xelatex = 'xelatex %O -halt-on-error -file-line-error %S';
$bibtex = 'upbibtex %O %B';
$biber = 'biber --bblencoding=utf8 -u -U --output_safechars';
$makeindex = 'upmendex -s jpbase -l %O -o %D %S';
$pdf_mode = 5;
if ($ENV{PWD} =~ /\/tex$/) {
    $aux_dir = '.';
    $out_dir = '..';
}

add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
    if ( $silent ) {
        my $ret = system "bib2gls --silent --group $_[0]";
    } else {
        my $ret = system "bib2gls --group $_[0]";
    };
    my ($base, $path) = fileparse( $_[0] );
    if ($path && -e "$base.glstex") {
        rename "$base.glstex", "$path$base.glstex";
    }
    local *LOG;
    $LOG = "$_[0].glg";
    if (!$ret && -e $LOG) {
        open LOG, "<$LOG";
        while (<LOG>) {
                if (/^Reading (.*\.bib)\s$/) {
            rdb_ensure_file( $rule, $1 );
            }
        }
        close LOG;
    }
    return $ret;
}