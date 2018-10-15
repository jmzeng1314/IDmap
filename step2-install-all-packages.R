rm(list=ls())
gpl_info=read.csv("gpl_biocPackage.csv",stringsAsFactors = F)
### first download all of the annotation packages from bioconductor
for (i in 1:nrow(gpl_info)){ 
  print(i)
  platform=gpl_info[i,20]
  platform=trimws(platform)
  #platformDB='hgu95av2.db'
  platformDB=paste(platform,".db",sep="")
  if(!require(platformDB,character.only = T)){
    BiocInstaller::biocLite(platformDB,suppressUpdates=T,ask=F)
  } 
}
