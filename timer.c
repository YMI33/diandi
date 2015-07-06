CFSimpleTimer ����:

int CFSimpleTimer(const char* name, CFSimpleTimerHndl hndl, void* usrData, 
        int start_sec, int start_nsec,
        int intv_sec, int intv_nsec,
        CFFdevents* evts)
{
    CFTimer* tmr;
    
    /* ���� CFSimpleTimerData���͵����ݽṹ����Ҫ��������Ҫ��������handle����ָ��
     * �Լ�����Ҫhandle������������ݣ���������Ա��*/
    struct CFSimpleTimerData *data = malloc(sizeof(struct CFSimpleTimerData));
    
    data->hndl = hndl; /* ͨ�����������handle����ָ�� */
    data->usrData = usrData; /* ͨ������������û����� */
    
    struct itimerspec it = { /* �趨timer�Ŀ�ʼʱ���Լ��������ʱ�� */
        .it_value = {start_sec, start_nsec},
        .it_interval = {intv_sec, intv_nsec},
    };

    /* ������������е㲻�⣬�Ҳ²����˼�ǣ�
     *      ������ĳ��ط������ _SimpleTimerAction��data��,
     *      ��data�ṹ���е�hndl �� usrData�Ӷ�����hndl(usrData)!!
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
    

�㿴�������Ǹ�����ָ��_SimpleTimerAction�������¶���ģ�
static void _SimpleTimerAction(CFTimer* tmr, void* data)
{
    struct CFSimpleTimerData *_data;
    CFSimpleTimerHndl hndl; /* ���CFSimpleTimerHndl ָ�����һ������
                            timerָ���usrData�ĺ���ָ�룬typedef CFTimer*(*CFSimpleTimerHndl)(CFTimer* tmr, void* usrData);
                            ���timer.h�еĶ��� */
    void *usrData;
    
    _data = data;
    usrData = _data->usrData;
    hndl = _data->hndl;
    if (!hndl(tmr, usrData)) {
        CFTimerDestroy(tmr);
        free(data);
    }
}

