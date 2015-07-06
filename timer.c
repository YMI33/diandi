CFSimpleTimer 剖析:

int CFSimpleTimer(const char* name, CFSimpleTimerHndl hndl, void* usrData, 
        int start_sec, int start_nsec,
        int intv_sec, int intv_nsec,
        CFFdevents* evts)
{
    CFTimer* tmr;
    
    /* 这种 CFSimpleTimerData类型的数据结构很重要，里面主要存放了你的handle函数指针
     * 以及你需要handle函数处理的数据，这两个成员。*/
    struct CFSimpleTimerData *data = malloc(sizeof(struct CFSimpleTimerData));
    
    data->hndl = hndl; /* 通过参数传入的handle函数指针 */
    data->usrData = usrData; /* 通过参数传入的用户数据 */
    
    struct itimerspec it = { /* 设定timer的开始时间以及间隔触发时间 */
        .it_value = {start_sec, start_nsec},
        .it_interval = {intv_sec, intv_nsec},
    };

    /* 下面这个函数有点不解，我猜测的意思是：
     *      函数在某块地方会调用 _SimpleTimerAction（data）,
     *      拆开data结构体中的hndl 和 usrData从而调用hndl(usrData)!!
     *      */
    tmr = CFTimerNew(name, &it, _SimpleTimerAction, data, evts);
    if (!tmr) {
        LCF_ERR_OUT(ERR_FREE_CSTD, "CFTimerNew() failed: %s\n", name);
    }
    return 0;
ERR_DESTROY_TMR:
    CFTimerDestroy(tmr);
ERR_FREE_CSTD:
    free(data);
ERR_OUT:
    return -1;
}
    

你看，上面那个函数指针_SimpleTimerAction就是如下定义的：
static void _SimpleTimerAction(CFTimer* tmr, void* data)
{
    struct CFSimpleTimerData *_data;
    CFSimpleTimerHndl hndl; /* 这个CFSimpleTimerHndl 指针就是一个接受
                            timer指针和usrData的函数指针，typedef CFTimer*(*CFSimpleTimerHndl)(CFTimer* tmr, void* usrData);
                            详见timer.h中的定义 */
    void *usrData;
    
    _data = data;
    usrData = _data->usrData;
    hndl = _data->hndl;
    if (!hndl(tmr, usrData)) {
        CFTimerDestroy(tmr);
        free(data);
    }
}

