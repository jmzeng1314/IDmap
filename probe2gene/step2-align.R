library(Rsubread)
# 推荐从ENSEMBL上面下载成套的参考基因组fa及基因注释GTF文件
dir='~/data/project/qiang/release1/Genomes/'
ref <- file.path(dir,'Homo_sapiens.GRCh38.dna.toplevel.fa')
buildindex(basename="reference_index",reference=ref)
## 是单端数据
reads <- temp
align(index="reference_index",readfile1=reads,
      output_file="alignResults.BAM",phredOffset=64) 
propmapped("alignResults.BAM")


