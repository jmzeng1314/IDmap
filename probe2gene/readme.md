# 芯片探针序列的基因组注释

前面我提到过有些芯片，各种地方都是找不到其设计的探针对应的基因的，但是探针序列一般会给出，比如：

```
Human LncRNA Expression Array V4.0 AS-LNC-H-V4.0 20,730 mRNAs and 40,173 LncRNAs 8*60K
```

以前我会简单的回答，其实就是芯片探针的重新注释，重点是 

- probe sequences 探针序列下载
- uniquely mapped to the human genome (hg19) by Bowtie without mismatch.  参考基因组下载及比对
- chromosomal position of lncRNA genes based on annotations from GENCODE (Release 23)坐标提取，最后使用bedtools进行坐标映射

三部曲罢了，不过感觉会linux的朋友不多，我还是用R来一波这个操作。

### 首先下载序列

这里我选择在GEO官网的GPL平台下载 :  https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL21827 

```r
rm(list = ls())  ## 魔幻操作，一键清空~
options(stringsAsFactors = F)
# 注意查看下载文件的大小，检查数据 
f='GPL21827_eSet.Rdata'

library(GEOquery)
# 这个包需要注意两个配置，一般来说自动化的配置是足够的。
#Setting options('download.file.method.GEOquery'='auto')
#Setting options('GEOquery.inmemory.gpl'=FALSE)
if(!file.exists(f)){
  gset <- getGEO('GPL21827', destdir="." )       ## 平台文件
  save(gset,file=f)   ## 保存到本地
}
load('GPL21827_eSet.Rdata')  ## 载入数据
class(gset)
length(gset)
gset 
colnames(Table(gset))
probe2symbol=Table(gset)[,c(1,4)]
all_recs=paste(apply(probe2symbol,1,function(x) paste0('>',x[1],'\n',x[2])),collapse = '\n')
temp <- tempfile()  ## 编程技巧，把变量写入临时文件~
write(all_recs, temp)

```

这个技巧我在生信菜鸟团博客发布过：http://www.bio-info-trainee.com/3732.html  芯片概况如下：

![](http://www.bio-info-trainee.com/wp-content/uploads/2018/12/Agilent-079487-GPL-in-R.png)

### 然后对人类的参考基因组构建索引并且比对

主要是参考基因组下载会耗费时间，还有构建索引耗时也很可观！

```r
library(Rsubread)
# 推荐从ENSEMBL上面下载成套的参考基因组fa及基因注释GTF文件
dir='~/data/project/qiang/release1/Genomes/'
ref <- file.path(dir,'Homo_sapiens.GRCh38.dna.toplevel.fa')
buildindex(basename="reference_index",reference=ref)
## 是单端数据，fa序列来源于上一个步骤输出的gpl的探针
reads <- temp
align(index="reference_index",readfile1=reads,
      output_file="alignResults.BAM",phredOffset=64) 
propmapped("alignResults.BAM")

```

构建大约耗时一个小时，具体如下：

![](http://www.bio-info-trainee.com/wp-content/uploads/2018/12/subread-index-hg38.png)

比对速度很快，因为探针序列只有6万多，如下：

![](http://www.bio-info-trainee.com/wp-content/uploads/2018/12/align-lncRNA-sequence.png)

在linux下得到比对后的bam文件也很简单的。



### 读入人类基因组注释文件

也是需要一点点R技巧，可以参考我在生信菜鸟团的博客：http://www.bio-info-trainee.com/3742.html  使用refGenome加上dplyr玩转gtf文件

```r
library(Rsubread)
# 推荐从ENSEMBL上面下载成套的参考基因组fa及基因注释GTF文件
dir='~/data/project/release1/Genomes/'
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
## 重点是要成为对象
library(GenomicRanges)
my_gr <- with(my_gene, GRanges(seqid, IRanges(start, end), 
                               strand, id = gene_id))
```

如果是linux的shell脚本，一句话就可以搞定其实。

### 坐标映射

把自己制作好的bam文件的坐标，跟提取自gtf文件的坐标信息对应起来，使用`GenomicRanges`包自带的函数即可。

值得注意的是把bam文件读入R，并且转为grange对象需要一点点技巧，我在生信菜鸟团博客写过：http://www.bio-info-trainee.com/3740.html

```r
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
```

当然，坐标映射本身也是满满的R技巧啦。




