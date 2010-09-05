#!/usr/bin/perl
#
# $Id: makelatexdep.pl,v 1.1 2003/04/29 14:59:56 lmb Exp lmb $
#
# Example:
#
# makelatexdep.pl Makefile.dep x1.tex x2.tex x3.tex ...
#
# Processes all LaTeX files given on the command line and scans them, as well
# as all included files, for dependencies; the resulting dependency
# information is written to Makefile.dep.
#
#
# Author: Lars Marowsky-Brée <lars@marowsky-bree.de>
#
# Copyright (C) 1999-2002 Lars Marowsky-Brée
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

my ($outfile,@texfiles) = @ARGV;

# Read through all the files, and determine who includes what,
# and which documents are document roots instead of mere includes.

while ($curfile = shift @texfiles) {
	if ($processed{$curfile} > 0) {
		# Skip, to avoid scanner loops
		next;
	} else {
		$processed{$curfile}++;
	}
	
	print "Processing $curfile: ";
	open (TEX,"<$curfile");
	
	while (<TEX>) {
		s/\%.*//;
		if (/\\includegraphics(?:\[.*?\])?\{(.*?)\}/
		  || /\\epsfig\{.*?file=([^,]+)/o) {
			my $f = $1;
			$f =~ s/\.(eps|pdf|png)$//;
			$includes{$curfile}{$f}++;
			print "(image $f) ";
		} elsif (/\\usepackage(\[.*?\])?\{thumbpdf\}/) {
			$includes{$curfile}{'THUMBNAILS'} = 1;
			print "(generating thumbnails) ";
		} elsif (/\\documentclass/) {
			print "(Is a document root) ";
			$texroots{$curfile}++;
		} elsif (/\\(include|input)\{(.+?)(\.tex)?\}/) {
			my $f = $2;
			if (-e "$f.tex") {
				$f .= '.tex';
			}
			print "(includes $f) ";
			push @texfiles, $f;
			
			$includes{$curfile}{$f}++;
		}
	}

	close TEX;
	print "\n";
}

# Okay, now we know what files are document roots, so we now generate
# the real dependency information for the respective pdf / dvi files.

foreach $curfile (keys %texroots) {
	
	my $basename = $curfile;
	$basename =~ s/\.tex$//o;
	
	my (@pdfdeps, @dvideps);
	
	my @refs = ($curfile);

	while ($inc = shift @refs) {
		if (-e "$inc.fig") {
			unshift @pdfdeps, "$inc.pdf";
			unshift @dvideps, "$inc.eps";
			push @figfiles, "$inc.fig";
		} elsif (-e "$inc.dia") {
			unshift @pdfdeps, "$inc.pdf";
			unshift @dvideps, "$inc.eps";
			push @diafiles, "$inc.dia";
		} elsif (-e "$inc.eps") {
			unshift @pdfdeps, "$inc.pdf";
			unshift @dvideps, "$inc.eps";
		} elsif (-e "$inc.png") {
			unshift @pdfdeps, "$inc.png";
		} elsif ($inc eq 'THUMBNAILS') {
			push @pdfdeps, "${basename}.tpt";
		} elsif ($inc =~ /\.tex$/) {
			# Okay, we need to follow the dependency here
			unshift @pdfdeps, $inc;
			unshift @dvideps, $inc;
			unshift @refs, (keys %{$includes{$inc}});
		} else {
			print "WARNING: I don't know how to provide $inc, required by $curfile\n";
			unshift @pdfdeps, $inc;
			unshift @dvideps, $inc;
		}
	}
	
	@{$deps{$basename.".dvi"}} = @dvideps; 
	@{$deps{$basename.".pdf"}} = @pdfdeps; 

}

# Now we know all...

open (MAKEDEP, ">$outfile");

print MAKEDEP "rootfiles := ".join(" ", keys %texroots)."\n\n";
print MAKEDEP "texfiles := ".join(" ", keys %processed)."\n\n";
print MAKEDEP "figs := ".join(" ", @figfiles)."\n\n";
print MAKEDEP "dias := ".join(" ", @diafiles)."\n\n";

foreach $f (sort keys %deps) {
	print MAKEDEP "$f: ".join(" ",@{$deps{$f}})."\n\n";
}

close MAKEDEP;

