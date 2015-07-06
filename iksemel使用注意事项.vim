iksemel库的使用注意点：

1. “有几个iks_new，就必须要有几个iks_delete”

直接上代码：
        iks *sub1, *test;
        char *p;

        test = iks_new("ctl");
        sub1 = iks_new("mid");
        iks_insert_attrib(sub1, "from", "llj@rd5.com");
        iks_insert_node(test, sub1);
        MDS_DBG("test: %s\n", iks_string(iks_stack(test), test));
        
        iks_delete(test);
        
        /* 以下是测试代码 */
        p = iks_find_attrib(sub1, "from");
        MDS_DBG("\n");
        if (p) {
            *(p+2) = 'l';
            MDS_DBG("mid: %s\n", iks_string(iks_stack(sub1), sub1));
        } else {
            MDS_DBG("p is NULL!!\n");
        }
        
        iks_delete(sub1);
你看，虽然释放了上层的test节点，但mid子节点的空间并没有释放掉！！所以，你还
必须再释放一次。是不是感觉很烦？？

其实，针对你的应用，可以这样来写；
        iks *sub1, *test;
        char *p;

        test = iks_new("ctl");
        sub1 = iks_insert(test, "mid"); /* 注意这行!!!!!! */
        iks_insert_attrib(sub1, "from", "llj@rd5.com");
        MDS_DBG("test: %s\n", iks_string(iks_stack(test), test));
        
        iks_delete(test);
        
        /* 以下是测试代码 */
        p = iks_find_attrib(sub1, "from");
        MDS_DBG("\n");
        if (p) {
            *(p+2) = 'l';/* 这行不会crash */
            MDS_DBG("mid: %s\n", iks_string(iks_stack(sub1), sub1)); /* 这行会crash掉 */
        } else {
            MDS_DBG("p is NULL!!\n");
        }
PS:至于为什么我释放掉的空间还是可读可写（46行），可能是因为那块区域暂时是闲置状态，但说不准什么时候会被其他进程
用到，如果你在写的时候正好其他进程在用，那46行也会crash。

你看，现在只需要一次iks_delete就可以了是不是很方便？

2. iks_new_within
iks *sub1 = iks_insert(root, "mid")  <==>   iks *sub1 = iks_new_within("mid", iks_stack(root));
                                            iks_insert_node(root, sub1);
所以，把上面第二个例子中36行换成右边两行是完全等价的。不过，感觉没必要啊~~~~~

within之后还必须insert,不然没效果的。



3. 关于如何处理iks*的参数
不要直接对参数进行操作，copy一份，用好了就delete掉。例如：
void fun(iks* xcmd)
{
        iks *dup;

        dup = iks_new("ctl");
        sub1 = iks_copy_within(xcmd, iks_stack(dup));
        iks_insert_node(dup, sub1);

        //各种对dup的操作。。。。


        iks_delete(dup);
}

原则是：每个函数管理释放自己的iks*，不要干涉其他程序。


4. 获取cdata
           iks *xtest = iks_tree("<ctl>lalalalalal</ctl>", 0, 0);
           char *xdata = iks_cdata(iks_child(xtest)); //why???!!!
           MDS_DBG("xdata: %s\n", xdata);

这里有个疑惑，xtest指向了根节点，为何还得iks_child??



