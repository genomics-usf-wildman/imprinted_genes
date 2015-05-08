#!/usr/bin/make -f

geneimprint_human.html:
	wget -O $@ "http://www.geneimprint.com/site/genes-by-species.Homo+sapiens"


parent_of_origin.html:
	wget -O $@ "http://igc.otago.ac.nz/FMPro?-DB=Catalogue.fm&-error=Error.html&-Format=Record3.html&Genetype=maingene&-SortField=Species&custom=Species&-SortField=Chr&custom=Chromosome&-SortField=Location&-SortOrder=Ascending&-Max=all&-Find"

geneimprint_human.txt: geneimprint_human.html parse_geneimprint.pl
	./parse_geneimprint.pl $< > $@

parent_of_origin.txt: parent_of_origin.html parse_parent_of_origin.pl
	./parse_parent_of_origin.pl $< > $@
