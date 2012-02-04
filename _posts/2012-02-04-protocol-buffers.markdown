---
layout: post
title: Google Protocol Buffer简介
Categories:
- 开源
- Google
---
在阅读Chromium Remoting源代码时，遇到了<code>.proto</code>文件。经过搜索，在Google Code上找到了对这种文件的详细说明：[Protocol Buffer][1]。这里，对这个机制做一简介。本文将以Python语言为例，介绍：
-<code>.proto</code>文件的格式
-使用protocol buffer编译器
-使用Python语言的protocol buffer API来读写消息
更多内容，请参阅[Protocol Buffer官方网站][1]。

##为什么要用Protocol Buffer？
对于结构化的数据，我们有很多方式来序列化/反序列化：
- 使用原始的二进制数据：即使用数据在内存中的映射作为数据流，但这种方式的兼容性非常差。
- 使用自定义的编码方式：例如，用字符串“12:3:-23:67”的方式保存这4个整数，对于简单的数据，这种方式还是比较好用的
。
- 使用XML进行序列化：这种方法兼容性很好，但显而易见的是，XML的开销很大。
相比之下，Protocol Buffer看起来要灵活很多。只需编写<code>.proto</code>文件来描述数据结构，即可使用Google提供的框架来完成数据的序列化/反序列化。此外，Protocol Buffer格式还支持数据的扩展，即使增加了新的域，通常也能够保证兼容性。

##定义一个协议（Protocol）
这里以一个电话本程序为例，设计一个<code>.proto</code>文件。定义一个<code>.proto</code>文件很简单：对每种需要序列化的数据结构编写一个*message*，然后给每个字段指明名称和类型即可。本例如下：
{% highlight html %}
package tutorial;

message Person {
  required string name = 1;
  required int32 id = 2;
  optional string email = 3;

  enum PhoneType {
    MOBILE = 0;
    HOME = 1;
    WORK = 2;
  }

  message PhoneNumber {
    required string number = 1;
    optional PhoneType type = 2 [default = HOME];
  }

  repeated PhoneNumber phone = 4;
}

message AddressBook {
  repeated Person person = 1;
}
{% endhighlight %}
<code>.proto</code>文件首先由package声明开始，用于防止项目间的名称冲突。在Python中，这个就不那么重要了，因为Python是以目录结构作为包划分。但是，为了跨语言访问，即使用Python，还是应该在文件的开始部分声明package。

接下来，我们定义了一个message。**message**是一些域的集合，域的类型可以是简单的数据类型，例如<code>bool</code>，<code>int32</code>，<code>float</code>，<code>double</code>以及<code>string</code>。域的类型还可以是复杂类型，例如上例中的<code>Person</code>类型的message中包含了<code>PhoneNumber</code>类型的message。此外，也可以定义枚举（<code>enum</code>）类型，例如这里的<code>PhoneType</code>。

“=1”，“=2”这样的记号是每个字段唯一的标记。简单来说，在传输时，传输的数据是这个标记，而不是域的名字。1-15在编码时使用较少的字节数，因此，对于常用的域，应当考虑使用1-15作为标记。

每个域必须包含一下修饰符之一：


[1]: http://code.google.com/intl/en/apis/protocolbuffers/
