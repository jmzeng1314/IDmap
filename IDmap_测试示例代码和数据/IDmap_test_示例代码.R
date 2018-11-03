##测试get_geneids()
##输入探针名和GPL号，会自动返回与probeid对应的gene id信息
test_matrix<-read.csv("C:\\Users\\admin\\Desktop\\GSE27284_series_matrix\\GSE27284_series_matrix.csv")
tmp <- get_geneids(test_matrix$ID_REF,"GPL8490")
head(tmp)

##测试get_geo()
##如果用户输入的GPL不在我们存储的数据中，会提醒用户使用get_geo() 从GEO官网下载注释
destDir="C:\\Users\\admin\\Desktop\\GSE27284_series_matrix\\"
zz <- get_geo("GPL890",destDir = destDir)
head(zz)

