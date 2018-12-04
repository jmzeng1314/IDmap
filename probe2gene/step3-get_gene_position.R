library(Rsubread)
# 推荐从ENSEMBL上面下载成套的参考基因组fa及基因注释GTF文件
dir='~/data/project/qiang/release1/Genomes/'
gtf <- file.path(dir,'Homo_sapiens.GRCh38.82.gtf')
if(!require(refGenome)) install.packages("refGenome")
# create ensemblGenome object for storing Ensembl genomic annotation data
ens <- ensemblGenome()
# read GTF file into ensemblGenome object
read.gtf(ens,useBasedir = F,gtf)

class(ens)  
# counts all annotations on each seqname
tableSeqids(ens) 
# returns all annotations on mitochondria
extractSeqids(ens, 'MT')
# summarise features in GTF file
tableFeatures(ens)
# create table of genes
my_gene <- getGenePositions(ens)
dim(my_gene)

# length of genes
gt=my_gene
my_gene_length <- gt$end - gt$start
my_density <- density(my_gene_length)
plot(my_density, main = 'Distribution of gene lengths')

library(GenomicRanges)
my_gr <- with(my_gene, GRanges(seqid, IRanges(start, end), 
                               strand, id = gene_id))

