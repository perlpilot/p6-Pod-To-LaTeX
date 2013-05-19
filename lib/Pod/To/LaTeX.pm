class Pod::To::LaTeX;

method render($pod) {
    process($pod);
}

multi sub process(Pod::Block::Named $p where *.name eq 'pod') {
    say "\\begin\{document\}";
    process($p.content);
    say "\\end\{document\}";
}

multi sub process(Str $s) { print $s; }
multi sub process(Array $a) { for @($a) -> $e { process($e) } }

multi sub process(Pod::Block::Comment $p) { 
    # do nothing for now
}

multi sub process(Pod::Block::Para $p) {
    latex("paragraph", $p);
}

multi sub process(Pod::Block::Named $p) {
    given $p.name {
        when 'TITLE'  {  latex("title", $p); }
        when 'AUTHOR' {  latex("author", $p); }
    }
}
multi sub process(Pod::FormattingCode $c) { 
    given $c.type {
        when 'B' { latex("textbf", $c) }
        when 'I' { latex("textit", $c) }
        when 'C' { latex("texttt", $c) }
        when 'U' { latex("underline", $c) }
        default { $*ERR.say: "Unknown code '$c'"; process($c.content) }
    }
}

multi sub process($x) {
    $*ERR.say: $x.WHAT;
}

sub latex($thingy,$pod) {
    print "\\$thingy\{";
    process($pod.content);
    print "\}";
    
}
