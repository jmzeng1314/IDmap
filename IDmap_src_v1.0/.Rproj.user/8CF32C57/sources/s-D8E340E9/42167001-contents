########################################
##                                    ##
## code last update: Dec 02, 2018     ##
##                                    ##
########################################

##' Download probe annotations from GEO
##'
##'
##' \code{get_geo} returns a list of gene ids for the input GPL Accession Number
##' @param GPL,destDir
##'
##' @return {get_geo} will download probe annotations from GEO ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
##'
##' @examples
##' get_geo("GPL13607", destdir=getwd())
##'
##' @importFrom GEOquery getGEO
##' @export

get_geo <- function(GPL,destDir=getwd()){
  pkg <- "GEOquery"
  require(pkg, character.only=TRUE)
  getGEO <- eval(parse(text="getGEO"))
  #Meta <- eval(parse(text="Meta"))
  destdir="geo_soft"
  if (!file.exists(destdir)) {
    dir.create(destdir)
  }
  info <- getGEO(GPL, destdir=destdir)
  ## http://www.ncbi.nlm.nih.gov/geo/info/soft2.html
  #metaInfo <- Meta(info)

  res <- Table(info)
  return(res)
}
