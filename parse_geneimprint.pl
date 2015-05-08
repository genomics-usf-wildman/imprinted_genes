#!/usr/bin/perl
# parse_geneimprint.pl Parses output from the geneimprint website and returns a table of imprinted genes
# and is released under the terms of the GNU GPL version 3, or any
# later version, at your option. See the file README and COPYING for
# more information.
# Copyright 2014 by Don Armstrong <don@donarmstrong.com>.


use warnings;
use strict;

use Getopt::Long;
use Pod::Usage;

=head1 NAME

parse_geneimprint.pl - Parses output from the geneimprint website and returns a table of imprinted genes

=head1 SYNOPSIS

parse_geneimprint.pl [options]

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

parse_geneimprint.pl geneimprint_human.html > geneimprint_human.txt

=cut


use vars qw($DEBUG);

use HTML::Tree;

my %options = (debug           => 0,
               help            => 0,
               man             => 0,
              );

GetOptions(\%options,
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

# the table we want is currently the first table
my $table = $t->look_down(_tag=>'table');
for my $row ($table->look_down(_tag=>'tr')) {
    print join("\t",map{my $a = $_->as_text(); $a =~ s/\xA0/ /g; $a;} $row->descendents())."\n";
}






__END__
