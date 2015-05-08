library(data.table)

args <- commandArgs(trailingOnly=TRUE)

geneimprint <- fread(args[1])
parent <- fread(args[2])
### fix up the 0 prefixed chromosomes
parent[,chr:=gsub("^0","",chromosome)]
### remove aliases in ()
parent[,Gene:=gsub("\\s*\\([^\\)]+\\)\\s*","",gene)]
### remove aliases after ,
parent[,Gene:=gsub("\\s*,\\s*.+","",Gene)]

parent <- parent[grepl("^[A-Z0-9]+$",Gene),]
setkey(parent,"Gene")
setkey(geneimprint,"Gene")

imprinted.genes <-
    union(parent[,Gene],geneimprint[,Gene])

write.table(file=args[length(args)],
            imprinted.genes,
            sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

