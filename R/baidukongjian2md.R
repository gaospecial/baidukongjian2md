baidukongjian2md <- function(url = "http://wenzhang.baidu.com/"){
  library(RSelenium)
  ## just check the browser version of Chrome and use same version of Driver
  # binman::list_versions("chromedriver")
  ## rsDriver() can download server and driver automatically
  driver<- rsDriver(browser=c("chrome"),
                    port = 4445L,
                    chromever = "92.0.4515.107",
                    geckover = NULL,
                    phantomver = NULL)
  remDr <- driver[["client"]]
  remDr$open()

  # login interface with SMS code
  remDr$navigate("https://passport.baidu.com/v2/?login")

  # scroll down to get all articles
  remDr$navigate(url)
  webElemBody <- remDr$findElement("css", "body")
  webElemBody$sendKeysToElement(list(key = "end"))

  # get blog url
  TOC_pageSource = remDr$getPageSource()[[1]]
  blog_url = blog_url(TOC_pageSource)

  # get blog content
  contents = lapply(blog_url, function(x){
    remDr$navigate(x)
    Sys.sleep(0.1)
    blogPageSource = remDr$getPageSource()[[1]]
    title = blog_title(blogPageSource)
    real_url = blog_content_url(blogPageSource)
    remDr$navigate(real_url)
    Sys.sleep(0.5)
    content = remDr$getPageSource()[[1]]
    file = tempfile(fileext = ".html", pattern = "Selenium")
    xfun::write_utf8(content, file)
    dplyr::tibble(
      title = title,
      content = file
    )
  })
  contents
}


blog_url = function(pageSource, url = "https://wenzhang.baidu.com/"){
  library(rvest)
  html = read_html(pageSource)
  elements = html %>% html_nodes("li.unit")

  # filter blog post
  blog_idx = elements %>% html_elements("div.mask .page-url") %>%
    html_text() %>%
    grep(pattern = "来自于百度空间")
  blog_entry = elements[blog_idx]
  blog_entry_url = blog_entry %>%
    html_elements(".content .unit-c a") %>%
    html_attr("href")
  blog_entry_url = paste0(url, blog_entry_url)
  return(blog_entry_url)
}

blog_title = function(pageSource){
  html = read_html(pageSource)
  html %>% html_node("title") %>% html_text()
}

blog_content_url = function(pageSource){
  html = read_html(pageSource)
  real_url = html %>% html_node("iframe") %>%
    html_attr("src")
  return(real_url)
}

blog_content = function(url){
  library(rvest)
  html = read_html(url)
  title = html %>% html_node("h1") %>% html_text()
  content = html %>% html_node("h1 > div")
  if (!is.character(title)) title = ""
  if (!is.character(content)) content = ""
  data.frame(title = title, content = content)
}



