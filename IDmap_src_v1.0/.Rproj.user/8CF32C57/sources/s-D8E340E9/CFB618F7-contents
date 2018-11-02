########################################
##                                    ##
## code last update: Dec 02, 2018     ##
##                                    ##
########################################


##' Mapping gene ids to probe ids
##'
##'
##' \code{get_geneids} returns a list of gene ids for the input probe ids
##' @param probeids,gpl
##'
##' @return if the input dataset is in our platform list(save in gpl_list.rda) ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
##'
##' @examples
##' data(package = "IDmap")
##' probeids <- c("1053_at","117_at","1316_at")
##' platform <- "GPL570"
##' geneids <- get_geneids(probeids,gpl)
##' head(geneids)
##'
##' probeids <- c("A_23_P101521","A_33_P3695548","A_33_P3266889")
##' platform <- "GPL10332"
##' geneids <- get_geneids(probeids,gpl)
##' head(geneids)
##
##'#目前存在查找结果冗余的情况
##' @export

get_geneids <- function (probeids,gpl) {

  if (missing(probeids)){
    stop("No valid probeids passed in !")
  }

  flag <- check_gpl(gpl)
  if(!flag){

    stop("please check your platform is in our gpl list \t
         or you can use function `get_anno_from_geo()` to annotate your probeids")
  }

  tryCatch(utils::data("spe_map", package = "IDmap"))
  spe_map <- get("spe_map")

  gpl_list <- get_gpl_list()
  spe_name <- gpl_list[gpl_list$gpl==gpl,3]

  biopack_status <- gpl_list[gpl_list$gpl==gpl,6]
  species <- names(which(spe_map==spe_name))

  datasets <- get_anno_data(species,biopack_status)

  multimap_gpl <- c("GPL8300","GPL91","GPL570","GPL14877","GPL3921","GPL17897","GPL6244","GPL17556","GPL11532","GPL18190","GPL1261","GPL8321")  #有多个gpl对应同一个biocpack的情况
  if(gpl %in% multimap_gpl){

  tmp <- datasets[grepl(gpl,datasets$gpl),]
  }else{

  tmp <- datasets[datasets$gpl==gpl,]
  }

  tmp <- tmp[which(tmp$probe_id %in% probeids),]
  #output_dat<-data.frame()
  #output_dat <- output_dat[probe_id = tmp$probe_id,gene_id = tmp$gene_id]
  return(tmp)
}

##'  Check the input gpl if is in our platform list
##'
##'
##' @param gpl
##'
##' @return returns a boolean value
##' @export
check_gpl <- function(gpl){

  gpl_list <- get_gpl_list()
  flag <- (gpl %in% gpl_list$gpl | gpl %in% gpl_list$bioc_package)
  return(flag)
}

##' Get annotation data
##'
##'
##' @param spe,biocpack_status
##'
##' @return returns annotation data
##' @export
get_anno_data <- function(spe,biopack_status){

  if(biopack_status == "0"){
    source_file = "gpl"

  }else{
    source_file = "biopack"
  }

  #Q1 能不能不全部加载数据，只加载目标数据
  data_name <- paste0(spe,"_data_from_",source_file)
  tryCatch(utils::data(package = "IDmap"))
  anno_data <- get(data_name)
  return(anno_data)
}

get_gpl_list <- function(){

  tryCatch(utils::data("gpl_list", package = "IDmap"))
  gpl_list <- get("gpl_list")
  return(gpl_list)
}
