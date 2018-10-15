# BiocInstaller::biocLite('GEOmetadb')
library(GEOmetadb)
f="/Users/jmzeng/data/project/IDmap/GEOmetadb.sqlite"
if(!file.exists(f)) getSQLiteFile()
# trying URL 'http://starbuck1.s3.amazonaws.com/sradb/GEOmetadb.sqlite.gz'
#  (439.8 MB)
file.info(f)
con <- dbConnect(SQLite(),f)
# http://www.bio-info-trainee.com/1085.html
# http://www.bio-info-trainee.com/1421.html
dbListTables(con)
dbListFields(con, "gpl")
tmp=dbGetQuery(con, 
           "select * from gpl ")
tmp=tmp[!is.na(tmp$bioc_package),]
tmp=tmp[nchar(tmp[,20])>1,]
tmp=tmp[!grepl('Methylati',tmp[,2]),]
write.csv(tmp,file = 'gpl_biocPackage.csv',row.names = F)
#bioc_package
dbDisconnect(con)

