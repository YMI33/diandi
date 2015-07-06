#ifdef DEBUG
    #define DBG(format, args...) \
    fprintf(stderr, "[D][%s:%d] ", __FILE__, __LINE__); \
    fprintf(stderr, format, ##args)
#else
    #define DBG(format, args...)
#endif

=======================================
这是可变参数宏的一个很好的应用。
带有可变参数的宏（Macros with a Variable Number of Arguments）
在1999年版本的ISO C 标准中，宏可以象函数一样，定义时可以带有可变参数。宏的语法和函数的语法类似。
下面有个例子：

#define debug(format, ...) fprintf (stderr, format, __VA_ARGS__)

这里，‘…'指可变参数。这类宏在被调用时，它（这里指‘…'）被表示成零个或多个符号，包括里面的逗号，一直到到右括弧结束为止。
当被调用时，在宏体（macro body）中，那些符号序列集合将代替里面的__VA_ARGS__标识符。更多的信息可以参考CPP手册。
GCC始终支持复杂的宏，它使用一种不同的语法从而可以使你可以给可变参数一个名字，如同其它参数一样。例如下面的例子：

#define debug(format, args...) fprintf (stderr, format, args)

这和上面举的那个ISO C定义的宏例子是完全一样的，但是这么写可读性更强并且更容易进行描述。
GNU CPP还有两种更复杂的宏扩展，支持上面两种格式的定义格式。
在标准C里，你不能省略可变参数，但是你却可以给它传递一个空的参数。例如，下面的宏调用在ISO C里是非法的，因为字符串后面没有逗号：

debug ("A message")

GNU CPP在这种情况下可以让你完全的忽略可变参数。在上面的例子中，编译器仍然会有问题（complain），因为宏展开后，里面的字符串后面会有个多余的逗号。
为了解决这个问题，CPP使用一个特殊的‘##'操作。
书写格式为：

#define debug(format, ...) fprintf (stderr, format, ## __VA_ARGS__)

这里，如果可变参数被忽略或为空，‘##'操作将使预处理器（preprocessor）去除掉它前面的那个逗号。
如果你在宏调用时，确实提供了一些可变参数，GNU CPP也会工作正常，它会把这些可变参数放到逗号的后面。象其它的pasted macro参数一样，这些参数不是宏的扩展。

