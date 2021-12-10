get_browser <- function(platform = .Platform$OS.type){
  if (platform == "windows") return("chrome")
}
