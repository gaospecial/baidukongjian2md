# 百度空间博文提取器

我曾经在百度空间上面写了几十篇博文。随着年龄的增大，有一种想要整理当年思绪的需求。 幸好，虽然百度空间关闭了，但是博文被妥善安置到了百度云（<http://wenzhang.baidu.com/>）。

本软件包的功能是批量的导出自己百度空间账号下面的博文，并将其转变的 Markdown， 以利于重新部署在自己的个人网站上去。

## 百度空间文章的特点

百度云文章只能通过 URL 访问到，文章列表默认只加载 100 篇，需要在页面中下拉到底才能显示完整。

文章内容通过 `iframe` 嵌入到网页中，不同页面具有不同的 CSS 结构。

使用一个在线的 HTML to Markdown 转换器（<https://codebeautify.org/html-to-markdown>）可以将 HTML 转换为 Markdown。
