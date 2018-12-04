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







