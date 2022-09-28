$bibtex_fudge = 0;

$bibtex = 'bibtex %O %S';
$bibtex_save = $bibtex;
$bibtex = 'internal bibtex_fix %R %D %S';

$clean_ext .= " %R-mod.blg %R-mod.aux %R-mod.bbl";

sub bibtex_fix {
    my ($root, $dest, $source) = @_;
    local ($base_tex, $path, $ext) = fileparse( $source, '\.[^\.]*' );
    my $ret = 0;
    if ( $base_tex eq $root ) {
        print "--- Will run bibtex on modified '$root.aux' file\n";
        my $aux_mod_base = $path.$base_tex."-mod";
        local $out_fh = new FileHandle "> $aux_mod_base$ext";
        if (!$out_fh) { die "Cannot write to '$aux_mod_base$ext'\n"; }
        local $level = 0;
        fix_aux( $source );
        close $out_fh;
        $ret = Run_subst( $bibtex_save, 2, undef, "$aux_mod_base.aux", undef, $aux_mod_base );
        foreach ( 'bbl', 'blg' ) {
           copy "$aux_mod_base.$_", "$path$root.$_";
        }
    }
    else {
        $ret = Run_subst( $bibtex_save );
    }
    return $ret;
}

sub fix_aux {
   # Read aux file, outputting flattened version to file handle $out_fh and
   # removing \bibdata and \bibstyle lines that were in included .aux files.
   my $aux_file = $_[0];
   print "Processing '$aux_file'\n";
   my $aux_fh = new FileHandle $aux_file;
   if (!$aux_fh) { die "$My_name: Couldn't read aux file '$aux_file'\n"; }
   $level++;
   while (<$aux_fh>) {
      if ( ($level > 1) &&
           ( /^\\bibdata\{(.*)\}/ || /^\\bibstyle\{(.*)\}/ )
         )
      { next; }
      elsif ( /^\\\@input\{(.*)\}/ ) {
          my $next_aux = $path.$1;
          my $bbl = $next_aux;
          $bbl =~ s/\.aux$/\.bbl/;
          fix_aux( $next_aux );
          if (! -e $bbl ) {
            # Create dummy bbl file, so that on next run
            # of *latex, it will be seen and reported
            # with correct path. This avoids bug in latexmk
            # 4.70b to 4.71a that latexmk assumes a wrong 
            # path for the bbl file when it doesn't exist.
            my $bbl_fh = new FileHandle "> $bbl";
            close $bbl_fh;
          }
          next;
      }
      else {
         print $out_fh $_;
      }
   }
   close($aux_fh);
   $level--;
}

##############
# Glossaries #
##############
=pod
add_cus_dep( 'glo', 'gls', 0, 'glo2gls' );
add_cus_dep( 'acn', 'acr', 0, 'glo2gls'); # from Overleaf v1
sub glo2gls {
    system("makeglossaries $_[0]");
}
=cut

add_cus_dep( 'acn', 'acr', 0, 'makeglossaries' );
add_cus_dep( 'glo', 'gls', 0, 'makeglossaries' );
add_cus_dep( 'ntn', 'not', 0, 'makeglossaries' );
$clean_ext .= " acr acn alg glo gls glg ist not ntn";

sub makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}

#############
# makeindex #
#############
@ist = glob("*.ist");
if (scalar(@ist) > 0) {
    $makeindex = "makeindex -s $ist[0] %O -o %D %S";
}

################
# nomenclature #
################
add_cus_dep("nlo", "nls", 0, "nlo2nls");
sub nlo2nls {
    system("makeindex $_[0].nlo -s nomencl.ist -o $_[0].nls -t $_[0].nlg");
}
