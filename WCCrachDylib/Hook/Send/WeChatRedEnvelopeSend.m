//
//  WeChatRedEnvelopeSend.m
//  WCCrachDylib
//
//  Created by ZongzhuHe on 2017/11/13.
//  Copyright © 2017年 ZongzhuHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CaptainHook/CaptainHook.h>
#import "HeaderForWeChat.h"

#import "PLConfig.h"
#import "PLSendRedEnvelopTaskManager.h"
#import "PLSendRedEnvelopOperation.h"
#import "PLSendRedEnvelopParamQueue.h"
#import "PLSendRedEnvelopParam.h"

#pragma mark - 发红包流程




// 微信团队：BrandContentLogicController
// 个人： WeixinContentLogicController
// 微信tabBar：NewMainFrameViewController
// 通讯录： ContactsViewController
//  发现： FindFriendEntryViewController
// 我： MoreViewController
// 群： BaseMsgContentViewController




/*
 *  获取进入聊天会话的 CContact
 */
CHDeclareClass(MMMsgLogicManager)
CHOptimizedMethod(6,self, void, MMMsgLogicManager, PushLogicControllerByContact,CContact *,arg1,navigationController,id,arg2,animated,BOOL,arg3,jumpToLocationNode,id,arg4,reuse,BOOL,arg5,extraInfo,id,arg6){
    CHSuper(6,MMMsgLogicManager, PushLogicControllerByContact,arg1,navigationController,arg2,animated,arg3,jumpToLocationNode,arg4,reuse,arg5,extraInfo,arg6);
    [PLSendRedEnvelopTaskManager sharedManager].chatContact = arg1;
}


/*
 *  自动生成红包信息
 */
CHDeclareClass(MMInputToolView)
CHOptimizedMethod1(self, void, MMInputToolView, onRedEnvelopesClicked, id, arg1){
    if([PLConfig sharedConfig].autoMake){
        PLSendRedEnvelopOperation *operation = [[PLSendRedEnvelopOperation alloc] initWithRedEnvelopParam:[PLSendRedEnvelopParam getParam] delay:0];
        [[PLSendRedEnvelopParamQueue sharedQueue] enqueue:operation];
        [[PLSendRedEnvelopTaskManager sharedManager] addSerialTask:operation];
        
    }else{
        CHSuper1(MMInputToolView, onRedEnvelopesClicked, arg1);
    }
}

/*
 *  自动支付
 */
CHDeclareClass(WCPayControlLogic)
CHOptimizedMethod2(self, void, WCPayControlLogic, showPayOrderConfirmViewWithData, WCPayControlData*, arg1, delegate, WCPayPayMoneyLogic*, arg2){
    
    if([PLConfig sharedConfig].autoPay){
        
        WCPayOrderPayConfirmView *view = [[objc_getClass("WCPayOrderPayConfirmView") alloc] initWithFrame:CGRectZero andData:arg1 delegate:arg2];
        WCPayTenpayPasswordCtrlItem *item =  CHIvar(view, m_textFieldItemPwd, __strong WCPayTenpayPasswordCtrlItem *);
        TenpayPasswordCtrl *textField =  CHIvar(item, m_textField, __strong TenpayPasswordCtrl *);
        
        NSRange range;
        for(int i=0; i<[PLConfig sharedConfig].pwd.length; i+=range.length){
            range = [[PLConfig sharedConfig].pwd rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *s = [[PLConfig sharedConfig].pwd substringWithRange:range];
            [textField appendPsw:s];
        }
        [view onPayBtnClick];
        
    }else{
        CHSuper(2, WCPayControlLogic,showPayOrderConfirmViewWithData,arg1,delegate,arg2);
    }
    
    
}

/*
 *  生成红包
 */
CHDeclareClass(WCRedEnvelopesSendControlLogic)
CHOptimizedMethod2(self, void, WCRedEnvelopesSendControlLogic, OnQueryRedEnvelopesUserInfo, id, arg1, Error, id, arg2){
    CHSuper2(WCRedEnvelopesSendControlLogic, OnQueryRedEnvelopesUserInfo, arg1, Error, arg2);
    if([PLConfig sharedConfig].autoMake){
        NSString *osskey = [arg1[@"operationNext"][@"ossKey"] stringValue];
        PLSendRedEnvelopOperation *operation = [[PLSendRedEnvelopParamQueue sharedQueue] getOperationWithOsskey:osskey];
        if (operation) {
            WCRedEnvelopesControlData *controlData = [operation.logic getData];
            [operation.logic OnMakeWCRedEnvelopesButtonClick:controlData];
        }
    }
}

CHConstructor{

    CHLoadLateClass(WCRedEnvelopesSendControlLogic);
    CHClassHook(2,WCRedEnvelopesSendControlLogic, OnQueryRedEnvelopesUserInfo,Error);
    
    CHLoadLateClass(MMMsgLogicManager);
    CHClassHook(6,MMMsgLogicManager, PushLogicControllerByContact,navigationController,animated,jumpToLocationNode,reuse,extraInfo);
    
    CHLoadLateClass(WCPayControlLogic);
    CHClassHook2(WCPayControlLogic, showPayOrderConfirmViewWithData, delegate);
    
    CHLoadLateClass(MMInputToolView);
    CHClassHook(1, MMInputToolView, onRedEnvelopesClicked);

}
