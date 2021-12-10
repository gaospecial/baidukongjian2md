#' Get data from baidu kongjian
#'
#'
#' @param remDr a browser client
#' @param url
#'
#' @return
#' @export
#'
#' @examples
baidukongjian <- function(remDr = remDr, index_url = "https://wenzhang.baidu.com/"){
  # scroll down to get all articles
  remDr$navigate(index_url)
  webElemBody <- remDr$findElement("css", "body")
  webElemBody$sendKeysToElement(list(key = "end"))

  # get blog url
  TOC_pageSource = remDr$getPageSource()[[1]]
  blog_url = blog_url(read_html(TOC_pageSource))

  # get blog content
  contents = lapply(blog_url, function(x){
    remDr$navigate(x)
    Sys.sleep(0.1)
    blogPageSource = remDr$getPageSource()[[1]]
    html = read_html(blogPageSource)
    # real_url can open directly but will expire in short time
    real_url = blog_content_url(html)
    content = read_html(real_url)
    dplyr::tibble(
      source = blogPageSource,
      real_url = real_url,
      content = list(content)
    )
  })
  contents = dplyr::bind_rows(contents)
  return(contents)
}



#' Start a browser
#'
#' @param browser only support chrome
#' @param chromever the version of your Chrome
#'
#' @return
#' @export
#'
#' @examples
start_browser = function(browser = "chrome", chromever = "96.0.4664.45"){
  # cleanup 4445 port
  killtask_by_port(4445)
  library(RSelenium)
  ## just check the browser version of Chrome and use same version of Driver
  # binman::list_versions("chromedriver")
  ## rsDriver() can download server and driver automatically
  driver<- rsDriver(browser = browser,
                    port = 4445L,
                    chromever = chromever,
                    geckover = NULL,
                    phantomver = NULL)
  remDr <- driver[["client"]]

  # login interface with SMS code
  remDr$navigate("https://passport.baidu.com/v2/?login")
  return(remDr)
}

killtask_by_port = function(port = 4445){
  task = system("netstat -aon", intern = TRUE)
  task = strsplit(task[grep(paste0("0.0.0.0:", port),task)], split = "\\s+")
  if (length(task)<1) return(NULL)
  pid = as.integer(task[[1]][[6]])
  tools::pskill(pid)
}


#' Get the links to all blog posts listed in content index page
#'
#' @param html content index page
#' @param base base url for post
#'
#' @return
#'
#' @examples
blog_url = function(html, base = "https://wenzhang.baidu.com/"){
  library(rvest)
  elements = html %>% html_nodes("li.unit")

  # filter blog post
  blog_idx = elements %>% html_elements("div.mask .page-url") %>%
    html_text(trim = TRUE) %>%
    grep(pattern = "来自于百度空间")
  blog_entry = elements[blog_idx]
  blog_entry_url = blog_entry %>%
    html_elements(".content .unit-c a") %>%
    html_attr("href")
  blog_entry_url = paste0(base, blog_entry_url)
  return(blog_entry_url)
}


#' Get the real url of a blog post
#'
#' blog post was embed in a iframe, and this function get the real link in the iframe.
#'
#' @param html
#'
#' @return
#'
#' @examples
blog_content_url = function(html){
  real_url = html %>% html_node("iframe") %>%
    html_attr("src")
  return(real_url)
}

#' Content of a blog post
#'
#' @param html
#'
#' @return
#' @export
#'
#' @examples
blog_content = function(html){
  tag_list = html %>% html_nodes(".tags-list > ul > li") %>% html_text(trim = TRUE)
  div_id = html %>% html_nodes("h1, div") %>% html_attr("id")
  title = html %>%
    html_node(paste0("#",div_id[grep("^detailArticleTitle", div_id)])) %>%
    html_text(trim = TRUE)
  content = html %>%
    html_node(paste0("#",div_id[grep("^detailArticleContent", div_id)]))
  footer = html %>%
    html_node(paste0("#",div_id[grep("^detailArticleFooter", div_id)]))
  time = footer %>% html_nodes(".time-cang") %>% html_text(trim = TRUE)
  time = gsub("收藏于\\s+", time, replacement = "")
  src = footer %>% html_nodes(".link-src") %>% html_text(trim = TRUE)
  src = gsub("来自于", src, replacement = "")

  dplyr::tibble(
    blog_title = title,
    tags = tag_list,
    blog_time = time,
    blog_src = src,
    blog_content = list(content)
  )
}



