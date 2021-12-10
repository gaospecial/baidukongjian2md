# Server and Driver Notes

To run a functional Selenium, both the Selenium server and at least one Webdriver are needed.

Webdriver can be managed by the **wbman** package. In this package, we just ported the latest version Webdriver of Chrome, PhantomJS, Edge, and Firefox.

- [x] [Selenium standalone binary](http://selenium-release.storage.googleapis.com/index.html)
- [x] [Chrome driver](https://chromedriver.storage.googleapis.com/index.html):  v92.0.4515.107
- [x] [PhantomJS binary](http://phantomjs.org/download.html)
- [x] [Firefox driver](https://github.com/mozilla/geckodriver/releases)
- [x] [Edge dirver](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/): v92.0.902.73
- [ ] [Internet Explorer driver](https://github.com/SeleniumHQ/selenium/wiki/InternetExplorerDriver)

WebDriver 还需要与浏览器软件配套使用，例如你的 Chrome 版本是 92.0，那么你下载的 Chrome Driver 也得是 92.0 版本的。

