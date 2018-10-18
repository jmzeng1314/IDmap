#read all GPL info (which download from NCBI-GEO)
all_gpl_info<-read.csv("all_GPL_info.csv",stringsAsFactors = F)

#set the species and companies that want to choose
species<-c("Homo sapiens","Mus musculus","Rattus norvegicus")
company<-c("Affymetrix, Inc.","Illumina Inc.","Agilent Technologies")

filter_species<-data.frame()
filter_company <- data.frame()

#filter species in human,mouse and rat
for (i in species){
  filter_species <- rbind(filter_species,all_gpl_info[which(i==all_gpl_info$Taxonomy),])
}

#After filter species,select the top 10% platforms from Affy,Agilent and Illumina
tmp <- lapply(company, function (x){
         filter_company <- filter_species[which(x==filter_species$Contact),]
         filter_company <- filter_company[order(filter_company[,6],decreasing=T),]
         top10_GPL<- filter_company[1:(nrow(filter_company)/10),]
         #output top10_GPL
         write.csv(as.data.frame(top10_GPL),paste0(strsplit(x,split=" ")[[1]][1],".csv"),row.names=F)
  
  })

