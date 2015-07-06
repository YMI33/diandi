unlink和remove小结
首先，我们得先理解linux下的两种文件链接方式
1、 硬链接
       指通过索引节点来进行链接。在linux文件系统中，保存在磁盘分区中的文件，不管是什么类型，都会给它分配一个编号，我们称之为
       inode号。同一个inode号可以有多个文件名，即可以拥有多个有效路径名。其用途就是用户可以创建重要文件的硬连接来防止误删。因
       为只有当一个文件的硬链接数为0时，才会真正删除该文件的inode号及其对应的数据块(data block)。
2、 软链接
       软链接也叫符号链接，类似于windows中的快捷方式，它是一种特殊的文本文件，里面保存着另一个文件的位置信息。
 
在命令行终端里，如何用shell命令创建硬连接和软链接呢
1、 shell创建文件
       $touch file1
2、 shell创建硬链接文件
       $ln file1 file2            #给文件file1创建一个硬连接文件file2
3、 shell创建 软链接文件
       $ln -s file1 file3       #给文件file1创建一个符号链接文件file3
此时用$ls -li(-i参数显示文件的inode信息)可以看到file2和file1拥有相同的inode号，而file3则有自己的inode号
实验小结：
                1）删除符号链接file3，对file1，file3无影响；
         2）删除硬连接file2，对file1,file3也无影响；
         3）删除原文件file1，对硬连接file2没有影响，而导致符号链接file3失效；
         4）同时删除原文件file1，硬连接file2，整个文件会真正被删除。
        注：在redhat中发现同时删除了file1,file2之后往file3里面写数据后保存退出再ls，却能还原出file1。
 
最后我们小结一下标题里提到的unlink和remove
    int remove(const char *pathname);  // #include <stdio.h>
    int unlink(const char *pathname);  // #include <unistd.h>
    int rmdir(const char *pathname);   // #include <unistd.h>
1、 对于文件，remove和unlink是一样的操作，对于目录，remove和rmdir是一样的操作；
2、 对于符号链接文件，remove和unlink不会删除其指向的文件，而只是删除该符号文件本身；
3、 如果所删除的文件只有最后一个硬链接，并且没有进程打开它，那么该文件会被彻底删除，其所占据的数据块空间会被释放。
4、 如果所删除的文件只有最后一个硬链接，但是仍然有进程打开它，那么文件会继续保持到与之关联的最后一个文件描述符被close后才会
       被删除。
5、 如果remove/unlink的文件名是一个socket、FIFO，或者其它设备，但有进程在open了这些socket、FIFO或者其它设备，那么这些进
       程依然能继续使用拥有该pathname的文件。
===========================================

1. 硬链接数 和 引用链接数 之间有什么关系吗？？

2. 当一个程序打开一个文件，该文件的引用链接数是多少？fclose()与unlink()的区别在哪儿？？unlink会对引用链接数有影响吗？
===========================================
Linux中link，unlink，close，fclose详解
每一个文件，都可以通过一个struct stat的结构体来获得文件信息，其中一个成员st_nlink代表文件的链接数。
       当通过shell的touch命令或者在程序中open一个带有O_CREAT的不存在的文件时，文件的链接数为1。

       通常open一个已存在的文件不会影响文件的链接数。open的作用只是使调用进程与文件之间建立一种访问关系，即open之后返回fd，调用进程可以通过fd来read 、write 、 ftruncate等等一系列对文件的操作。
       close()就是消除这种调用进程与文件之间的访问关系。自然，不会影响文件的链接数。在调用close时，内核会检查打开该文件的进程数，如果此数为0，进一步检查文件的链接数，如果这个数也为0，那么就删除文件内容。

       link函数创建一个新目录项，并且增加一个链接数。
       unlink函数删除目录项，并且减少一个链接数。如果链接数达到0并且没有任何进程打开该文件，该文件内容才被真正删除。如果在unlilnk之前没有close，那么依旧可以访问文件内容。
  
       综上所诉，真正影响链接数的操作是link、unlink以及open的创建。
       删除文件内容的真正含义是文件的链接数为0，而这个操作的本质完成者是unlink。close能够实施删除文件内容的操作，必定是因为在close之前有一个unlink操作。

      举个例子简单说明：通过shell   touch test.txt
 1、stat("test.txt",&buf);
      printf("1.link=%d\n",buf.st_nlink);//未打开文件之前测试链接数

 2、fd=open("test.txt",O_RDONLY);//打开已存在文件test.txt
      stat("test.txt",&buf);
      printf("2.link=%d\n",buf.st_nlink);//测试链接数

 3、close(fd);//关闭文件test.txt
      stat("test.txt",&buf);
      printf("3.link=%d\n",buf.st_nlink);//测试链接数

 4、link("test.txt","test2.txt");//创建硬链接test2.txt
       stat("test.txt",&buf);
       printf("4.link=%d\n",buf.st_nlink);//测试链接数

 5、unlink("test2.txt");//删除test2.txt
      stat("test.txt",&buf);
      printf("5.link=%d\n",buf.st_nlink);//测试链接数

6、重复步骤2  //重新打开test.txt

7、unlink("test.txt");//删除test.txt
     fstat(fd,&buf);
     printf("7.link=%d\n",buf.st_nlink);//测试链接数

8、close(fd);//此步骤可以不显示写出，因为进程结束时，打开的文件自动被关闭。

    顺次执行以上8个步骤，结果如下：
    1.link=1
    2.link=1    //open不影响链接数
    3.link=1    //close不影响链接数
    4.link=2    //link之后链接数加1
    5.link=1    //unlink后链接数减1
    2.link=1    //重新打开  链接数不变
    7.link=0    //unlink之后再减1，此处我们改用fstat函数而非stat，因为unlilnk已经删除文件名，所以不可以通过   文件名访问，但是fd仍然是打开着的，文件内容还没有被真正删除，依旧可以使用fd获得文件信息。
   执行步骤8，文件内容被删除。。。。

