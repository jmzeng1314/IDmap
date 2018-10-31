########################################
##                                    ##
## code last update: Oct 31, 2018     ##
##                                    ##
########################################


##' Mapping gene ids to probe ids
##'
##'
##' \code{get_geneids} returns a list of gene ids for the input probe ids
##' @param probeids,platform,plt.choose
##' if plt.choose is TRUE , then shows the input is gpl ,else is platform
##'
##' @return if the input dataset is in our platform list(save in gpl_list.rda) ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
##'
##' @examples
##' data(package = "IDmap")
##' probeids <- c("1000_at","1001_at","1002_f_at")
##' platform <- "hcg110"
##' geneids <- get_geneids(probeids,platform,plt.choose=F)
##' head(geneids)
##'
##' probeids <- c("A_23_P101521","A_33_P3695548","A_33_P3266889")
##' platform <- "GPL10332"
##' geneids <- get_geneids(probeids,platform,plt.choose=T)
##' head(geneids)
##
##'#目前存在查找结果冗余的情况
##' @export
get_geneids <- function (probeids,platform,plt.choose=T) {

  if (missing(probeids)){
    stop("No valid probeids passed in !")
  }
  if (missing(platform)){
    stop("No valid platform passed in !")
  }
  flag <- check_gpl(platform)
  if(!flag){

    stop("please check your platform is in our gpl list \t
         or you can use function `get_anno_from_geo()` to annotate your probeids")
  }


  if(plt.choose){
  output_data <- get_geneids_from_gpl(probeids,platform)
  }else{
  output_data <- get_geneids_from_biocpack(probeids,platform)
  }

  return(output_data)
}


##' Get_geneids_from_gpl
##'
##'
##' \code{get_geneids} returns a list of gene ids for the input probe ids
##' @param probeids,gpl
##'
##' @return if the input dataset is in our platform list(save in gpl_list.rda) ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
get_geneids_from_gpl <- function (probeids,gpl) {

  tryCatch(utils::data("spe_map", package = "IDmap"))
  spe_map <- get("spe_map")

  gpl_list <- get_gpl_list()
  spe_name <- gpl_list[gpl_list$gpl==gpl,3]

  biopack_status <- gpl_list[gpl_list$gpl==gpl,6]
  species <- names(which(spe_map==spe_name))

  datasets <- get_anno_data(species,biopack_status)

  tmp <- datasets[datasets$platform==gpl,]
  tmp <- tmp[which(tmp$probe_id %in% probeids),]
  #output_dat<-data.frame()
  #output_dat <- output_dat[probe_id = tmp$probe_id,gene_id = tmp$gene_id]
  return(tmp)
}

##' Get_geneids_from_biocpack
##'
##'
##' \code{get_geneids} returns a list of gene ids for the input probe ids
##' @param probeids,gpl
##'
##' @return if the input dataset is in our platform list(save in gpl_list.rda) ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
##'
get_geneids_from_biocpack <- function (probeids,platform) {

  tryCatch(utils::data("spe_map", package = "IDmap"))
  spe_map <- get("spe_map")

  gpl_list <- get_gpl_list()
  spe_name <- gpl_list[gpl_list$bioc_package==platform,3]

  species <- names(which(spe_map==spe_name))
  biopack_status <- gpl_list[gpl_list$bioc_package==platform,6]

  datasets <- get_anno_data(species,biopack_status)

  tmp <- datasets[datasets$platform==platform,]
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

##' get annotation data
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
