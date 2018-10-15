rm(list=ls())
gpl_info=read.csv("gpl_biocPackage.csv",stringsAsFactors = F)
library(annotate)
tail(sort(table(gpl_info$organism)))
get_dat <- function(spe){
  tmp <- lapply(gpl_info[gpl_info$organism==spe,20], function(x){ 
    platform=trimws(x)
    # platform='hgu95av2'
    platformDB=paste(platform,".db",sep="")
    if(!require(platformDB,character.only = T)){
      BiocInstaller::biocLite(platformDB,suppressUpdates=T,ask=F)
    }else{
      library(platformDB,character.only = T) 
      eval(parse(text = paste('keytypes(',platformDB,')',sep='')))
      all_probe=eval(parse(text = paste('mappedkeys(',platform,'ENTREZID)',sep='')))
      print(length(all_probe))
      EGID <- as.numeric(lookUp(all_probe, platformDB, "ENTREZID"))
      return(data.frame(platform=platform,
                        probe_id=all_probe,
                        gene_id=EGID))
    } 
  }) 
  tmp=do.call(rbind,tmp)
  return(tmp)
}
human_dat <- get_dat('Homo sapiens')
mouse_dat <- get_dat('Mus musculus')
rat_dat <- get_dat('Rattus norvegicus')
save(human_dat,mouse_dat,rat_dat,file = 'all_probeid2geneid.Rdata')
