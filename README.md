# IDmap

准备收集整理一切表达芯片探针的ID，并且对应到entrez系统的基因ID

首先需要了解一下表达芯片的主要公司及其生产的芯片历史，可以参考我两年前的总结：https://mp.weixin.qq.com/s/HoRUzx0UJxgkgQDxouj8rw 

然后需要参考我两年前的博客，收集有对应的bioconductor包的探针ID集，http://www.bio-info-trainee.com/1399.html   

最后还需要整理GEO里面的那些没有bioconductor对应包的GPL的信息，同样是常见的平台及常见的物种：https://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms&display=20&zsort=samples



### 已经完成

在jimmy个人电脑下载安装了80个bioconductor的芯片相关R包，并且把 3个物种的ID提取成功，具体详见代码。

xiangyujia-已下载GEO数据库的所有GPL信息，并获取了三大公司（Affy ， Agilent，Illumina）的前10%的GPL的信息（物种限定人类，小鼠与大鼠）

xiangyujia-已下载GPL对应的probe-gene注释信息

xiangyujia-已获取top10 GPL平台的所有注释信息
+ 成功提取probe id和gene id
+ 合并所提取的GPL平台probeid2geneid注释和来自bioconductor包的注释，存放在all_common_probeid2geneid.Rdata中

xiangyujia-IDmap v1.0版本源码上传
+ IDmap v1.0版本包含1个函数get_geneids，用于annotate probeids to geneids 。函数文档正在完善，其它函数正在编写中


