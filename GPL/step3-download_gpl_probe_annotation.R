#setwd("E:\\GPL_soft\\")
#source("https://bioconductor.org/biocLite.R")
#biocLite("GEOquery")

library(GEOquery)
gpl_not_in_biopack <- read.csv("IDmap\\GPL\\gpl_not_in_biopack.csv")
gpl_accession<-gpl_not_in_biopack$Accession
  
for(i in 1:length(gpl_accession)){

print(i)
#getGEO()会自动下载soft文件到指定目录
gpl <- getGEO(gpl_accession[i], destdir=".")
#获取注释信息后,保存为csv文件输出
output_path <- paste0("E:\\GPL_probe_annotation\\",gpl_accession[i],"_probe_anno.csv")
write.csv(Table(gpl),output_path)

}