#!/usr/bin/perl
# parse_parent_of_origin.pl Parses output from the parent_of_origin website and returns a table of imprinted genes
# and is released under the terms of the GNU GPL version 3, or any
# later version, at your option. See the file README and COPYING for
# more information.
# Copyright 2014 by Don Armstrong <don@donarmstrong.com>.


use warnings;
use strict;

use Getopt::Long;
use Pod::Usage;

=head1 NAME

parse_parent_of_origin.pl - Parses output from the parent_of_origin website and returns a table of imprinted genes

=head1 SYNOPSIS

parse_parent_of_origin.pl [options]

 Options:
   --debug, -d debugging level (Default 0)
   --help, -h display this help
   --man, -m display manual

=head1 OPTIONS

=over

=item B<--debug, -d>

Debug verbosity. (Default 0)

=item B<--help, -h>

Display brief usage information.

=item B<--man, -m>

Display this manual.

=back

=head1 EXAMPLES

parse_parent_of_origin.pl parent_of_origin.html > parent_of_origin.txt

=cut


use vars qw($DEBUG);

use HTML::Tree;

my %options = (debug           => 0,
               help            => 0,
               man             => 0,
               taxon           => 'Human',
              );

GetOptions(\%options,
           'taxon=s',
           'debug|d+','help|h|?','man|m');

pod2usage() if $options{help};
pod2usage({verbose=>2}) if $options{man};

$DEBUG = $options{debug};

my @USAGE_ERRORS;
if (@ARGV != 1) {
    push @USAGE_ERRORS,"You must provide a single html file";
}

pod2usage(join("\n",@USAGE_ERRORS)) if @USAGE_ERRORS;

my $t = HTML::Tree->new_from_file($ARGV[0]) or
    die "Unable to parse $ARGV[0]";

my @imprinted_genes;
use Data::Printer;
# the table we want is currently the first table
for my $table ($t->look_down(_tag=>'table')) {
    my @elements = map {$_->as_text()} $table->look_down(_tag => 'td');
    my %row = map {s/:$//g if defined $_; $_;} @elements[0..7];
    if (defined $row{Taxon} and
        lc($row{'Taxon'}) eq lc($options{taxon})) {
        push @imprinted_genes,\%row;
    }
}

print "chromosome\tgene\ttaxon\n";
for my $gene (@imprinted_genes) {
    print join("\t",map {$_ = defined $_?$_:''; s/[\x93"\x94]//g; $_}
               @{$gene}{qw(Chromosome Gene Taxon)})."\n";
}






__END__
