#' Stop RSelenium server
#'
#' @param pid
#'
#' @return
#' @export
#'
#' @examples
kill_server <- function(pid){
  tools::pskill(pid)
}

#' Start a RSelenium server automatically
#'
#' @param port server port
start_server <- function(port = 4445L){
  server_path = system.file("bin",package = "baidukongjian2md")
  if (!check_java()) stop("You need to install Java first.")
  chromedirver = paste(server_path, "chromedriver.exe", sep = "/")
  firefoxdriver = paste(server_path, "geckodriver.exe", sep = "/")
  phantomjsdirver = paste(server_path, "phantomjs.exe", sep = "/")
  serverjar = paste(server_path, "selenium-server-standalone-4.0.0-alpha-2.jar", sep = "/")
  cmd = sprintf("java -Dwebdriver.chrome.dirver='%s' -Dwebdriver.gecko.driver='%s' -Dphantomjs.binary.path='%s' -jar %s -port %d",
                chromedirver,
                firefoxdriver,
                phantomjsdirver,
                serverjar,
                port)
  pid = sys::exec_background(cmd)
  return(pid)
}

check_java <- function(){
  java = system("java -version")
  if (java == 0) return(TRUE)
  return(FALSE)
}
