---
layout: post
title: gedit的乱码问题
categories:
- Linux
- gnome
---
默认情况下，用gedit打开GB18030/GBK/GB2312编码的文件会乱码。这是因为，gedit有一个自己的编码列表，只有列表中的编码才会进行匹配。因此，解决方法是修改编码列表，将GB18030加入其中。
###安装dconf-editor
{% highlight bash %}
$ sudo apt-get install dconf-tools
{% endhighlight %}

###修改设置
运行dconf-editor，展开<code>org/gnome/gedit/preferences/encodings</code>，在<code>auto-detected</code>的<code>value</code>中的UTF8后面加入'GB18030'，在<code>show-in-menu</code>的value中加入'GB18030'即可。
