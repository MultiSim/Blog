---
layout: post
title: Google Protocol Buffer简介
categories:
- 开源
- Google
---
在阅读Chromium Remoting源代码时，遇到了<code>.proto</code>文件。经过搜索，在Google Code上找到了对这种文件的详细说明：[Protocol Buffer][1]。这里，对这个机制做一简介。本文将以Python语言为例，介绍：

- <code>.proto</code>文件的格式
- 使用Protocol Buffer编译器
- 使用Python语言的Protocol Buffer API来读写消息

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

  enum PhoneType {GO
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

- <code>required</code>：字段值不能为空，否则会产生异常。
- <code>optional</code>：字段值如果没有设置，则使用默认值，如果没有指定默认值，则使用系统默认值，例如0，空字符串等。
- <code>repeated</code>：字段可以重复出现任意自然数次。值的顺序会被保留。

关于<code>.proto</code>文件写法的完整规则，请参见[Protocol Buffer Language Guide](http://code.google.com/intl/zh-CN/apis/protocolbuffers/docs/proto.html)。

##编译Protocol Buffer
完成<code>.proto</code>文件后，接下来需要生成可以读写<code>AddressBook</code>的类。这一工作通过使用<code>protoc</code>程序完成：

1. 安装编译器。[下载安装包](http://code.google.com/p/protobuf/downloads/)，按照README的提示操作。
2. 运行编译器：

{% highlight html %}
protoc --python_out=. addressbook.proto
{% endhighlight %}

这样会在当前目录下生成<code>addressbook\_pb2.py</code>文件。

##Protocol Buffer API
Python版的编译器并不生成读写数据的代码，而是生成message的描述符，通过Google提供的库来访问。

可以这样使用Protocol Buffer：

{% highlight python %}
import addressbook_pb2
person = addressbook_pb2.Person()
person.id = 1234
person.name = "John Doe"
person.email = "jdoe@example.com"
phone = person.phone.add()
phone.number = "555-4321"
phone.type = addressbook_pb2.Person.HOME
{% endhighlight %}

###枚举类型
枚举类型的值和<code>.proto</code>文件中指定的值一样。因此，以<code>addressbook_pb2.Person.WORK</code>为例，其值为2。

###Message的一般方法
- <code>IsInitialized()</code>：检查所有的required字段是否都已赋值
- <code>CopyFrom(other_msg)</code>：用other_msg替换当前的message
- <code>Clear()</code>：清空message

更多信息，请参见[Message的API文档](http://code.google.com/intl/zh-CN/apis/protocolbuffers/docs/reference/python/google.protobuf.message.Message-class.html)。

###解析和序列化
- <code>SerializeToString()</code>：将message序列化，并得到一个字符串。注意，这里的字符串只作为二进制数据的容器。
- <code>ParseFromString(data)</code>：把字符串解析为message。

最后，以两个例子（写、读message）作为本文的结束：

{% highlight python %}
#! /usr/bin/python

import addressbook_pb2
import sys

# This function fills in a Person message based on user input.
def PromptForAddress(person):
  person.id = int(raw_input("Enter person ID number: "))
  person.name = raw_input("Enter name: ")

  email = raw_input("Enter email address (blank for none): ")
  if email != "":
    person.email = email

  while True:
    number = raw_input("Enter a phone number (or leave blank to finish): ")
    if number == "":
      break

    phone_number = person.phone.add()
    phone_number.number = number

    type = raw_input("Is this a mobile, home, or work phone? ")
    if type == "mobile":
      phone_number.type = addressbook_pb2.Person.MOBILE
    elif type == "home":
      phone_number.type = addressbook_pb2.Person.HOME
    elif type == "work":
      phone_number.type = addressbook_pb2.Person.WORK
    else:
      print "Unknown phone type; leaving as default value."

# Main procedure:  Reads the entire address book from a file,
#   adds one person based on user input, then writes it back out to the same
#   file.
if len(sys.argv) != 2:
  print "Usage:", sys.argv[0], "ADDRESS_BOOK_FILE"
  sys.exit(-1)

address_book = addressbook_pb2.AddressBook()

# Read the existing address book.
try:
  f = open(sys.argv[1], "rb")
  address_book.ParseFromString(f.read())
  f.close()
except IOError:
  print sys.argv[1] + ": Could not open file.  Creating a new one."

# Add an address.
PromptForAddress(address_book.person.add())

# Write the new address book back to disk.
f = open(sys.argv[1], "wb")
f.write(address_book.SerializeToString())
f.close()
{% endhighlight %}

{% highlight python %}
#! /usr/bin/python

import addressbook_pb2
import sys

# Iterates though all people in the AddressBook and prints info about them.
def ListPeople(address_book):
  for person in address_book.person:
    print "Person ID:", person.id
    print "  Name:", person.name
    if person.HasField('email'):
      print "  E-mail address:", person.email

    for phone_number in person.phone:
      if phone_number.type == addressbook_pb2.Person.MOBILE:
        print "  Mobile phone #: ",
      elif phone_number.type == addressbook_pb2.Person.HOME:
        print "  Home phone #: ",
      elif phone_number.type == addressbook_pb2.Person.WORK:
        print "  Work phone #: ",
      print phone_number.number

# Main procedure:  Reads the entire address book from a file and prints all
#   the information inside.
if len(sys.argv) != 2:
  print "Usage:", sys.argv[0], "ADDRESS_BOOK_FILE"
  sys.exit(-1)

address_book = addressbook_pb2.AddressBook()

# Read the existing address book.
f = open(sys.argv[1], "rb")
address_book.ParseFromString(f.read())
f.close()

ListPeople(address_book)
{% endhighlight %}

##参考文献
[Protocol Buffer Basics: Python](http://code.google.com/intl/en/apis/protocolbuffers/docs/pythontutorial.html)

[1]: http://code.google.com/intl/en/apis/protocolbuffers/
