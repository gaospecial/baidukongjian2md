#' Convert html to markdown by online service
#'
#' @param con html content
#'
#' @return
#' @export
#'
#' @examples
html2md <- function(x){
  service = "https://codebeautify.org/html-to-markdown?input="
  request = URLencode(enc2utf8(paste0(service, x)))
  return(request)
}
