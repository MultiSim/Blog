---
layout: post
title: Google Protocol Buffer简介
Catogeries:
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
-使用原始的二进制数据：即使用数据在内存中的映射作为数据流，但这种方式的兼容性非常差。
-使用自定义的编码方式：例如，用字符串“12:3:-23:67”的方式保存这4个整数，对于简单的数据，这种方式还是比较好用的。
-使用XML进行序列化：这种方法兼容性很好，但显而易见的是，XML的开销很大。
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

[1]: http://code.google.com/intl/en/apis/protocolbuffers/
