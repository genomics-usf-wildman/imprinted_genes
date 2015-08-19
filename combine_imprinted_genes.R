library(data.table)

args <- commandArgs(trailingOnly=TRUE)

geneimprint <- fread(args[1])
geneimprint <- geneimprint[!grepl(" ",Gene),]
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
    union(gsub("[\\*\\@]$","",parent[,Gene]),
          gsub("[\\*\\@]$","",geneimprint[,Gene]))

gene.aliases <- fread(args[3])
setkey(gene.aliases,"alias")

imprinted.genes <-
    sort(sapply(imprinted.genes,
           function(x){if(is.na(gene.aliases[x,gene])) {
                           return(x)
                       } else {
                           return(gene.aliases[x,gene])
                       }}))

write.table(file=args[length(args)],
            imprinted.genes,
            sep="\t",row.names=FALSE,col.names=FALSE,quote=FALSE)

