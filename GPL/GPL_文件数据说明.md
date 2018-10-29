### **GPL文件夹文件说明**

+ **all_GPL_info.csv ：** 此文件是从GEO数据库下载的包含所有GPL信息的文件（数据获取时间是10月17日）

**数据概览：**

|Accession	|Title|	Technology	|Taxonomy	|Data Rows|	Samples Count	|Series Count|	Contact	|Release Date|
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
GPL570 |	[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array|	in situ oligonucleotide	|Homo sapiens|	54675|	143181|	5000	|Affymetrix, Inc.|	7-Nov-03|

+ **Affymetrix,.csv ,Agilent.csv,Illumina.csv :** 这三份.csv文件，是使用代码**step1-get_top10_gpl_info.R**  从 **all_GPL_info.csv** 中提取的每个公司前10%的GPL信息。

+ **gpl_not_in_biopack.csv:** 这份.csv文件，是使用代码**step2-get_gpl_info_not_in_biopack.R** 所获得的，不在**gpl_biocPackage.csv**中的，top10%的GPL的信息。（即，Bioconductor包中没有的，前10%的GPL信息）

【注：gpl_not_in_biopack.csv文件不包含SNP芯片和miRNA芯片的GPL信息，（即，处于top10%的snp,miRNA的gpl已被我人工删除）】

+ **GPL_probe2gene.rar：** 此文件是- 不在Bioconductor包中，但是处于top10%的，所有gpl的探针id-基因id注释信息（共26个GPL）
由代码**step3-download_gpl_probe_annotation.R** 获得

+ **all_common_probeid2geneid.Rdata** ：此文件就是将ID注释信息转化为Rdata的最终存储文件，包含所有来自Bioconductor的注释和非Bioconductor注释（即存放在IDmap中的数据来源）
由代码**step4-save_all_probe_annotation.R**获得
