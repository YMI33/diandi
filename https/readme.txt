"Legend(谭海燕)的专栏
Someone to love. Something to hope. Something to do.

 Network ? C/C++
Https(SSL/TLS)原理详解"

有两张图显示不出来，如果想看的话，就用网页代理搜原博客吧。

=========== 基本流程 ===========
（1） 客户端向服务器端索要并验证公钥。
（2） 双方协商生成"对话密钥"。
（3） 双方采用"对话密钥"进行加密通信。

上面过程的前两步，又称为"握手阶段"（handshake）。

来自阮一峰 http://www.ruanyifeng.com/blog/2014/02/ssl_tls.html，里面有三个参考资料链接，如果你想彻底搞懂https
有时间就好好研究研究他们吧。

还有一个好资料，讲得非常清楚!!：
https://rhsecurity.wordpress.com/2013/07/24/transport-layer-security/

