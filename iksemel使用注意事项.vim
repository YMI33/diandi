iksemel���ʹ��ע��㣺

1. ���м���iks_new���ͱ���Ҫ�м���iks_delete��

ֱ���ϴ��룺
        iks *sub1, *test;
        char *p;

        test = iks_new("ctl");
        sub1 = iks_new("mid");
        iks_insert_attrib(sub1, "from", "llj@rd5.com");
        iks_insert_node(test, sub1);
        MDS_DBG("test: %s\n", iks_string(iks_stack(test), test));
        
        iks_delete(test);
        
        /* �����ǲ��Դ��� */
        p = iks_find_attrib(sub1, "from");
        MDS_DBG("\n");
        if (p) {
            *(p+2) = 'l';
            MDS_DBG("mid: %s\n", iks_string(iks_stack(sub1), sub1));
        } else {
            MDS_DBG("p is NULL!!\n");
        }
        
        iks_delete(sub1);
�㿴����Ȼ�ͷ����ϲ��test�ڵ㣬��mid�ӽڵ�Ŀռ䲢û���ͷŵ��������ԣ��㻹
�������ͷ�һ�Ρ��ǲ��Ǹо��ܷ�����

��ʵ��������Ӧ�ã�����������д��
        iks *sub1, *test;
        char *p;

        test = iks_new("ctl");
        sub1 = iks_insert(test, "mid"); /* ע������!!!!!! */
        iks_insert_attrib(sub1, "from", "llj@rd5.com");
        MDS_DBG("test: %s\n", iks_string(iks_stack(test), test));
        
        iks_delete(test);
        
        /* �����ǲ��Դ��� */
        p = iks_find_attrib(sub1, "from");
        MDS_DBG("\n");
        if (p) {
            *(p+2) = 'l';/* ���в���crash */
            MDS_DBG("mid: %s\n", iks_string(iks_stack(sub1), sub1)); /* ���л�crash�� */
        } else {
            MDS_DBG("p is NULL!!\n");
        }
PS:����Ϊʲô���ͷŵ��Ŀռ仹�ǿɶ���д��46�У�����������Ϊ�ǿ�������ʱ������״̬����˵��׼ʲôʱ��ᱻ��������
�õ����������д��ʱ�����������������ã���46��Ҳ��crash��

�㿴������ֻ��Ҫһ��iks_delete�Ϳ������ǲ��Ǻܷ��㣿

2. iks_new_within
iks *sub1 = iks_insert(root, "mid")  <==>   iks *sub1 = iks_new_within("mid", iks_stack(root));
                                            iks_insert_node(root, sub1);
���ԣ�������ڶ���������36�л����ұ���������ȫ�ȼ۵ġ��������о�û��Ҫ��~~~~~

within֮�󻹱���insert,��ȻûЧ���ġ�



3. ������δ���iks*�Ĳ���
��Ҫֱ�ӶԲ������в�����copyһ�ݣ��ú��˾�delete�������磺
void fun(iks* xcmd)
{
        iks *dup;

        dup = iks_new("ctl");
        sub1 = iks_copy_within(xcmd, iks_stack(dup));
        iks_insert_node(dup, sub1);

        //���ֶ�dup�Ĳ�����������


        iks_delete(dup);
}

ԭ���ǣ�ÿ�����������ͷ��Լ���iks*����Ҫ������������


4. ��ȡcdata
           iks *xtest = iks_tree("<ctl>lalalalalal</ctl>", 0, 0);
           char *xdata = iks_cdata(iks_child(xtest)); //why???!!!
           MDS_DBG("xdata: %s\n", xdata);

�����и��ɻ�xtestָ���˸��ڵ㣬Ϊ�λ���iks_child??



