# IDmap

准备收集整理一切表达芯片探针的ID，并且对应到entrez系统的基因ID

首先需要了解一下表达芯片的主要公司及其生产的芯片历史，可以参考我两年前的总结：https://mp.weixin.qq.com/s/HoRUzx0UJxgkgQDxouj8rw 

然后需要参考我两年前的博客，收集有对应的bioconductor包的探针ID集，http://www.bio-info-trainee.com/1399.html   

最后还需要整理GEO里面的那些没有bioconductor对应包的GPL的信息，同样是常见的平台及常见的物种：https://www.ncbi.nlm.nih.gov/geo/browse/?view=platforms&display=20&zsort=samples



### 已经完成

**2018-11-03** IDmap v1.0版本基础功能实现
+ 使用测试文件夹中的测试数据可测试IDmap的基本功能
+ 可查看函数文档，可阅读简单版IDmap指南

**2018-11-02** IDmap v1.0版本更新
+ 完善probeid注释函数 get_geneids()
+ 增加自动从GEO下载probe注释的函数get_geo()
+ 为来自bioconductor的probe注释增加gpl信息
+ IDmap_0.1.0.zip windows平台二进制包上传，可安装至R 并正常使用函数

**2018-10-31** IDmap v1.0版本更新
+ 可实现基础的probeid注释，编译后可作为R包使用

**2018-10-29** xiangyujia-IDmap v1.0版本源码上传
+ （存放在IDmap目录下，IDmap_src_v1.0.zip，是未经编译的源码R包）
+ IDmap v1.0版本包含1个函数get_geneids，用于annotate probeids to geneids 。函数文档正在完善，其它函数正在编写中

**2018-10-24** xiangyujia-已获取top10 GPL平台的所有注释信息
+ （存放在GPL文件夹中）
+ 成功提取probe id和gene id
+ 合并所提取的GPL平台probeid2geneid注释和来自bioconductor包的注释，存放在all_common_probeid2geneid.Rdata（在IDmap目录下,不是GPL文件夹）中
+ step1,2,3,4 是下载注释，提取id和处理数据的代码
+ 注：GPL文件夹中的所有数据来源和代码具体说明，请查看GPL文件夹中的**GPL_文件来源和数据信息代码说明.md**

**2018-10-22** xiangyujia-已下载GPL对应的probe-gene注释信息
+ （存放在GPL文件夹中）

**2018-10-17** xiangyujia-已下载GEO数据库的所有GPL信息
+ 并获取了三大公司（Affy ， Agilent，Illumina）的前10%的GPL的信息（物种限定人类，小鼠与大鼠）

在jimmy个人电脑下载安装了80个bioconductor的芯片相关R包，并且把 3个物种的ID提取成功，具体详见代码。

