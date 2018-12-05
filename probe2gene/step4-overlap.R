library(Rsamtools)
bamFile="alignResults.BAM"
quickBamFlagSummary(bamFile)
# https://kasperdanielhansen.github.io/genbioconductor/html/Rsamtools.html
bam <- scanBam(bamFile)
bam
names(bam[[1]])
tmp=as.data.frame(do.call(cbind,lapply(bam[[1]], as.character)))
tmp=tmp[tmp$flag!=4,] # 60885 probes
#  intersect() on two GRanges objects.
library(GenomicRanges)
my_seq <- with(tmp, GRanges(as.character(rname), 
                                 IRanges(as.numeric(pos)-60, as.numeric(pos)+60), 
                                 as.character(strand), 
                                 id = as.character(qname)))
gr3 = intersect(my_seq,my_gr)
gr3
o = findOverlaps(my_seq,my_gr)
o
lo=cbind(as.data.frame(my_seq[queryHits(o)]),
         as.data.frame(my_gr[subjectHits(o)]))
head(lo)
write.table(lo,file = 'GPL21827_probe2ensemb.csv',row.names = F,sep = ',')



