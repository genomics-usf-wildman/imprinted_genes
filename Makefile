#!/usr/bin/make -f

R=R
ROPTS=-q --no-save --no-restore-data

all: imprinted_genes_information.txt

geneimprint_human.html:
	wget -O $@ "http://www.geneimprint.com/site/genes-by-species.Homo+sapiens"

geneimprint_mouse.html:
	wget -O $@ "http://www.geneimprint.com/site/genes-by-species.Mus+musculus"


parent_of_origin.html:
	wget -O $@ "http://igc.otago.ac.nz/FMPro?-DB=Catalogue.fm&-error=Error.html&-Format=Record3.html&Genetype=maingene&-SortField=Species&custom=Species&-SortField=Chr&custom=Chromosome&-SortField=Location&-SortOrder=Ascending&-Max=all&-Find"


geneimprint_human.txt: geneimprint_human.html parse_geneimprint.pl
	./parse_geneimprint.pl $< > $@

geneimprint_mouse.txt: geneimprint_mouse.html parse_geneimprint.pl
	./parse_geneimprint.pl $< > $@

parent_of_origin.txt: parent_of_origin.html parse_parent_of_origin.pl
	./parse_parent_of_origin.pl $< > $@

parent_of_origin_mouse.txt: parent_of_origin.html parse_parent_of_origin.pl
	./parse_parent_of_origin.pl --taxon Mouse $< > $@

imprinted_genes.txt: combine_imprinted_genes.R geneimprint_human.txt \
	parent_of_origin.txt gene_aliases.txt
	$(R) $(ROPTS) -f $< --args $(wordlist 2,$(words $^),$^) $@

imprinted_genes_information.txt: imprinted_genes.txt
	~/projects/chaim/bin/gene_info < $< > $@

imprinted_genes_mouse.txt: combine_imprinted_genes.R geneimprint_mouse.txt \
	parent_of_origin_mouse.txt gene_aliases_mouse.txt
	$(R) $(ROPTS) -f $< --args $(wordlist 2,$(words $^),$^) $@
