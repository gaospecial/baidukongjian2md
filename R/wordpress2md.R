
wordpress_blog2md = function(blog, metadata = c("title","date","slug","tags"), output_dir = "markdown"){
  metadata = blog[metadata]
  metadata$slug = paste0(metadata$date, "-", metadata$slug)
  header = yaml_header(metadata)
  html_file = tempfile(fileext = ".html")
  markdown_file = tempfile(fileext = ".md")
  xfun::write_utf8(blog$content, html_file)
  rmarkdown::pandoc_convert(html_file, to = "gfm", output = markdown_file)
  markdown = xfun::read_utf8(markdown_file)
  xfun::write_utf8(header, markdown_file)
  xfun::append_utf8(markdown, markdown_file, sort = FALSE)
  markdown_file2 = file.path(output_dir, paste0(metadata$slug, ".md"))
  fs::file_copy(markdown_file, markdown_file2, overwrite = TRUE)
  invisible(NULL)
}

pandoc_html2md = function(html_file, markdown_file){
  cmd = paste("pandoc", '-t', "markdown_strict", '-f', "html", '-o', markdown_file, file)
  system(cmd, intern = TRUE)
}


yaml_header = function(data){
  d = as.yaml(data)
  paste0("---\n",d,"---\n\n")
}
