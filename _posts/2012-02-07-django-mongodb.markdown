---
layout: post
title: Django与MongoDB
categories:
- Django
- MongoDB
---
要在Django中使用MongoDB，用[Django官网](http://djangoproject.com)上的版本是不行的，必须使用内建NoSQL支持的[Django-nonrel](http://www.allbuttonspressed.com/projects/django-nonrel)版本，同时安装[djangotoolbox](http://www.allbuttonspressed.com/projects/djangotoolbox)，最后安装[Django MongoDB Engin](http://django-mongodb.org)。

考虑到各种库的影响，通常很多人都推荐使用[virtualenv](http://virtualenv.org/)来配置环境。

###virtualenv###
以在virtualenv中配置为例进行说明（如果不想用virtualenv，请跳过本节）：

首先安装virtualenv：

{% highlight bash %}
$ pip install virtualenv
{% endhighlight %}

设置虚拟环境：

{% highlight bash %}
$ virtualenv myproject
{% endhighlight %}

在Bash中进入虚拟环境：
{% highlight bash %}
$ source myproject/bin/activate
{% endhighlight %}

###Django-nonrel###
{% highlight bash %}
$ pip install hg+https://bitbucket.org/wkornewald/django-nonrel
{% endhighlight %}

###djangotoolbox###
{% highlight bash %}
$ pip install hg+https://bitbucket.org/wkornewald/djangotoolbox
{% endhighlight %}

###Django MongoDB Engine###
{% highlight bash %}
$ pip install git+https://github.com/django-nonrel/mongodb-engine
{% endhighlight %}

##配置##
配置数据库非常容易：
{% highlight python %}
DATABASES = {
   'default' : {
      'ENGINE' : 'django_mongodb_engine',
      'NAME' : 'my_database'
   }
}
{% endhighlight %}

##Tips##
1. 虽然MongoDB是不在乎Schema的，但是使用前仍然需要运行<code>./manage.py syncdb</code>。
2. <code>settings.py</code>中的<code>SITE_ID</code>默认是1，而MongoDB中的ID是字符串，所以需要运行<code>./manage.py tellsiteid</code>得到实际的SITE_ID填写在这里。
