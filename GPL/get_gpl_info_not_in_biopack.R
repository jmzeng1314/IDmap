#setwd("F:\\IDmap\\")

#read the gpl_biocPackage.csv
bioc_pack <- read.csv("gpl_biocPackage.csv",stringsAsFactors = F)

#set the company name
company <- c("Affymetrix,","Agilent","Illumina")
top10_GPL_bind_result <- data.frame()
for(i in company){
      file <- read.csv(paste0("GPL\\",i,".csv") , stringsAsFactors = F)  
      top10_GPL_bind_result<-rbind(top10_GPL_bind_result,file)
}

#找出Bioconductor包中没有的GPL平台，并获取这些GPL的信息
gpl_intersect <- intersect(bioc_pack$gpl,top10_GPL_bind_result$Accession)
gpl_list <- setdiff(top10_GPL_bind_result$Accession,gpl_intersect)


gpl_not_in_biopack <- top10_GPL_bind_result[which(top10_GPL_bind_result$Accession %in% gpl_list),]
write.csv(gpl_not_in_biopack,"GPL\\gpl_not_in_biopack.csv",row.names = F)
