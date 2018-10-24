# 程序说明：
# 提取所有不在bioconductor包中的GPL文件的probe注释信息的probe id 和 gene id 
# 部分注释文件没有gene id 就以 Gene Symbol替代
# 本程序将不在biconductor中的注释和来自bioconductor-package的注释合并成最终注释文件

#### STEP0 首先读取不在biopack中的gpl-list信息,并且按公司分类进行注释文件的提取(不同公司注释文件格式不同)
gpl_list <- read.csv("IDmap\\GPL\\gpl_not_in_biopack.csv")
company <- c("Affymetrix","Agilent","Illumina")

#### STEP1 get probe annotation from agilent,由于不同公司的anno文件格式不同，需要分开处理
agilent_probe_result <- data.frame()  
gpl_list_agilent <- gpl_list[grepl(company[2],gpl_list$Contact),]

# i = c(1:nrow(gpl_list_agilent)) , 由于不同注释文件的id列不一样，需要手动设置i，进行文件读取和id选择
#注：GPL_gene_probe_annotation文件夹下的文件是由soft文件得到的probe2gene的注释文件,体积太大没有上传
i=1
a <- read.csv(paste0('GPL_gene_probe_annotation\\',gpl_list_agilent[i,1],"_probe_anno.csv")
              ,stringsAsFactors = F)

# 查看注释文件的情况
head(a)
colnames(a)
nrow(a)
# 手动选择gene_id和probe_id
tmp <- data.frame(platform = rep(gpl_list_agilent[i,1],times = nrow(a)),
                   title = rep(gpl_list_agilent[i,2],times = nrow(a)),
                   species = rep(gpl_list_agilent[i,4],times = nrow(a)),
                   probe_id = a$NAME,
                   gene_id = a$GENE
                     )

head(tmp)
print(nrow(tmp))
write.csv(tmp,paste0('IDmap\\GPL\\GPL_probe2gene\\',gpl_list_agilent[i,1],"_probe2gene.csv"))


#### STEP2 get probe annotation from affy,由于不同公司的anno文件格式不同，需要分开处理
affy_probe_result <- data.frame()  
gpl_list_affy <- gpl_list[grepl(company[1],gpl_list$Contact),]

# i = c(1:nrow(gpl_list_affy)) , 由于不同注释文件的id列不一样，需要手动设置i，进行文件读取和id选择
i=1
a <- read.csv(paste0('GPL_gene_probe_annotation\\',gpl_list_affy[i,1],"_probe_anno.csv")
              ,stringsAsFactors = F)
head(a)
colnames(a)
nrow(a)

# affy的有些注释文件的列是合并的字符串,所以需要我们按"//"分割gene_assignment
# 例如 gene_assignment列：NR_046018 // DDX11L1 // DEAD/H (Asp-Glu-Ala-Asp/His) box helicase 11 like 1 // 1p36.33 // 100287102 ///
# install.packages("tidyverse")
library(tidyverse)
a_split <- separate(data = a, into = c("refseqID","symbol","name","zz","entrez_id","other"),col = gene_assignment,  sep = "//")
head(a_split)

tmp <- data.frame(platform = rep(gpl_list_affy[i,1],times = nrow(a_split)),
                  title = rep(gpl_list_affy[i,2],times = nrow(a_split)),
                  species = rep(gpl_list_affy[i,4],times = nrow(a_split)),
                  probe_id = a_split$ID,
                  gene_id = a_split$entrez_id
)

head(tmp)
print(nrow(tmp))
write.csv(tmp,paste0('IDmap\\GPL\\GPL_probe2gene\\',gpl_list_affy[i,1],"_probe2gene.csv"))


#### STEP3 get probe annotation from Illumina,由于不同公司的anno文件格式不同，需要分开处理
Illumina_probe_result <- data.frame()  
gpl_list_Illumina <- gpl_list[grepl(company[3],gpl_list$Contact),]

### i = c(1:nrow(gpl_list_Illumina)) , 由于不同注释文件的id列不一样，需要手动设置i，进行文件读取和id选择
i = 1
a <- read.csv(paste0('GPL_gene_probe_annotation\\',gpl_list_Illumina[i,1],"_probe_anno.csv")
              ,stringsAsFactors = F)
head(a)
colnames(a)
nrow(a)
# 手动设置a$ID和a$Gene_ID
tmp <- data.frame(platform = rep(gpl_list_Illumina[i,1],times = nrow(a)),
                  title = rep(gpl_list_Illumina[i,2],times = nrow(a)),
                  species = rep(gpl_list_Illumina[i,4],times = nrow(a)),
                  probe_id = a$ID,
                  gene_id = a$Gene_ID
)

head(tmp)
print(nrow(tmp))
write.csv(tmp,paste0('IDmap\\GPL\\GPL_probe2gene\\',gpl_list_Illumina[i,1],"_probe2gene.csv"))

#### STEP4 合并所有注释文件
rm(list=ls())
load("IDmap\\all_probeid2geneid.Rdata")
ls()

all_files=list.files("IDmap\\GPL\\GPL_probe2gene",pattern = 'csv')
all_probe2gene <- data.frame()
for(i in 1:length(all_files)){
  print(i)
  a = read.csv(file.path('IDmap\\GPL\\GPL_probe2gene',all_files[i]))[-1]
  all_probe2gene <- rbind(all_probe2gene,a)
}

head(all_probe2gene)


#### STEP5 save all data
human_data_from_gpl <- all_probe2gene[grepl("Homo sapiens",all_probe2gene$species),]
mouse_data_from_gpl <- all_probe2gene[grepl("Mus musculus",all_probe2gene$species),]
rat_data_from_gpl <- all_probe2gene[grepl("Rattus norvegicus",all_probe2gene$species),]

#nrow(human_data)+nrow(mouse_data)+nrow(rat_data)
#nrow(all_probe2gene)

human_data_from_biopack <- human_dat
mouse_data_from_biopack <- mouse_dat
rat_data_from_biopack <- rat_dat

save(human_data_from_gpl,
     mouse_data_from_gpl,
     rat_data_from_gpl,
     human_data_from_biopack,
     mouse_data_from_biopack,
     rat_data_from_biopack,
     file = 'IDmap\\all_common_probeid2geneid.Rdata')
