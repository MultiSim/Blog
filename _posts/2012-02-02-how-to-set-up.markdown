---
layout: post
title: 如何搭一个这样的Blog？
categories:
- Blog
---
想搭一个这样的Blog，首先需要拥有一个[github](http://github.com)的账号。利用github的pages功能，即可放网页上去。

不难发现这个Blog完全是静态的，因此，一个显而易见的方法就是做一个静态的Blog，放在上面。但这不是一个geek的做法，因此，我们考虑使用jekyll这样的工具来完成。

使用jekyll可以去[jekyllbootstrap](http://jekyllbootstrap.com)按照tutorial进行。最简单的方法还是在github上[fork我的源码](https://github.com/terro/Blog)，然后在shell中执行：

{% highlight bash %}
$ bundle install
$ bundle exec ejekyll
{% endhighlight %}

即可在*\_site*目录下生成编译好的网站。最后将这个网站同步到USERNAME.github.com的项目中即可。

关于jekyll的使用，请见[jekyllbootstrap](http://jekyllbootstrap.com)，不再赘述。这里简述一下使用我的源码的注意事项：

1\. 根目录下的*projects.html*使用jQuery的github插件获取了github项目列表，请根据实际需求修改用户名。

2\. 根目录下的_\*.xml_文件请根据实际情况修改。

3\. 模版位于*\_layouts*目录下，请根据自身情况修改*default.html*文件中的信息、disqus（一个评论服务提供商）的id和Google Analytics的id，并根据自身情况修改*post.html*文件中的AddThis Button的id和disqus的id。

4\. 为了方便部署，我编写了名为*git.sh*的shell脚本，可根据情况修改使用。
