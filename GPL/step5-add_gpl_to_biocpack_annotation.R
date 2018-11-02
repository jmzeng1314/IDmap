##add gpl info to biocpackage data

gpl_biocpack<-read.csv("gpl_biocPackage.csv",stringsAsFactors = F)
data(package="IDmap")

add_gpl <- function(anno_data,gpl_biocpack,species){
  print(nrow(anno_data))
  count=0
  result<-data.frame()
  platform_list <- unique(anno_data$platform)

  for(x in platform_list)
  { print(x)
    flag=1
    tp <- anno_data[anno_data$platform == x,]
    if(x=="hgu95av2"){
      gpl <- "GPL8300/GPL91"
      flag=0
    }
    if(x=="hgu133plus2"){
      gpl <- "GPL570/GPL14877"
      flag=0
    }
    if(x=="hthgu133a"){
      gpl <- "GPL3921/GPL17897"
      flag=0
    }
    if(x=="hugene10sttranscriptcluster"){
      gpl <- "GPL6244/GPL17556"
      flag=0
    }
    if(x=="hugene11sttranscriptcluster"){
      gpl <- "GPL11532/GPL18190"
      flag=0
    }
    if(x=="mouse430a2"){
      gpl <- "GPL1261/GPL8321"
      flag=0
    }
    if(flag){
    gpl <- gpl_biocpack[which(gpl_biocpack$bioc_package == x & gpl_biocpack$organism == species),3]
    }

    tp$gpl <- rep(gpl,times=nrow(tp))
    count=nrow(tp)+count
    result<-rbind(result,tp)
  }

  print(count)
  return(result)
}



human_add_gpl<-add_gpl(human_data_from_biopack,gpl_biocpack,"Homo sapiens")
mouse_add_gpl<-add_gpl(mouse_data_from_biopack,gpl_biocpack,"Mus musculus")
rat_add_gpl<-add_gpl(rat_data_from_biopack,gpl_biocpack,"Rattus norvegicus")


#save(human_add_gpl,mouse_add_gpl,rat_add_gpl,file = 'all_probeid2geneid_add_gpl_no_redual.Rdata')

