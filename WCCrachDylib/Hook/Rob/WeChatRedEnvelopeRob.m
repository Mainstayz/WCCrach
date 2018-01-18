//
//  WeChatRedEnvelopeRob.m
//  WCCrachDylib
//
//  Created by ZongzhuHe on 2017/11/13.
//  Copyright © 2017年 ZongzhuHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>
#import "HeaderForWeChat.h"

#import "PLOpenRedEnvelopParamQueue.h"
#import "PLOpenRedEnvelopOperation.h"
#import "PLOpenRedEnvelopTaskManager.h"
#import "PLOpenRedEnvelopParam.h"
#import "PLConfig.h"



#pragma mark - 抢红包流程

/*
 判断是否该抢：
 1.   获取红包url  —> 解析 成 字典
 2.  通知WCRedEnvelopesLogicMgr接收到红包啦（ReceiverQueryRedEnvelopesRequest） ————> 向服务器发出请求。。。。
 3.  把1得到的字典加入查询队列
 4.  WCRedEnvelopesLogicMgr 接收到 OnWCToHongbaoCommonResponse，HongBaoRes 可以拿到 步骤2返回的红包结果
 5.  如果查询队列中的钱包签名 等于  HongBaoReq 的签名
 6.  获取HongBaoRes的timingIdentifier。 通知 WCRedEnvelopesLogicMgr OpenRedEnvelopesRequest 抢红包
 
 */


CHDeclareClass(WCRedEnvelopesLogicMgr)
CHOptimizedMethod(2,self,void,WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse,HongBaoRes *,arg1,Request,HongBaoReq *,arg2){
    
    CHSuper(2,WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse, arg1, Request, arg2);
    CHLog(@"[[### WCRedEnvelopesLogicMgr-OnWCToHongbaoCommonResponse ###]");
    NSLog(@"arg1.cgiCmdid = %d",arg1.cgiCmdid);
    
    if (arg1.cgiCmdid == 3 ) {
        NSLog(@"点开红包Cell");
        
            // 返回签名
        NSString *(^parseRequestSign)(void) = ^NSString *() {
            NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
            NSDictionary *requestDictionary = [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:requestString separator:@"&"];
            NSString *nativeUrl = [[requestDictionary stringForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
            NSDictionary *nativeUrlDict = [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
            NSLog(@"（请求信息：）HongBaoReq *requestDictionary = %@. nativeUrlDict = %@",requestDictionary,nativeUrlDict);
            return [nativeUrlDict stringForKey:@"sign"];
        };
        
        
            // 获取响应字典
        NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];
        
        NSLog(@" (响应信息：) HongBaoRes *responseDict = %@",responseDict);
        
            // 拿出队列头部的参数
        PLOpenRedEnvelopParam *mgrParams = [[PLOpenRedEnvelopParamQueue sharedQueue] dequeue];
        
        BOOL (^shouldReceiveRedEnvelop)(void) = ^BOOL() {
            
            
                // 手动抢红包
            if (!mgrParams) { return NO; }
            
                // 自己已经抢过
            if ([responseDict[@"receiveStatus"] integerValue] == 2) { return NO; }
            
                // 红包被抢完
            if ([responseDict[@"hbStatus"] integerValue] == 4) { return NO; }
            
                // 没有这个字段会被判定为使用外挂
            if (!responseDict[@"timingIdentifier"]) { return NO; }
            
                // 如果是自己发
            if (mgrParams.isGroupSender) {
                return [PLConfig sharedConfig].autoReceiveEnable;
            } else {
                    // 如果队列的红包签名相等，且打开的自动接收
                return [parseRequestSign() isEqualToString:mgrParams.sign] && [PLConfig sharedConfig].autoReceiveEnable;
            }
        };
        
        
        if (shouldReceiveRedEnvelop()) {
            
            mgrParams.timingIdentifier = responseDict[@"timingIdentifier"];
            
            double configDelaySeconds = [PLConfig sharedConfig].delaySeconds;
            
                // 抢红包动作
            PLOpenRedEnvelopOperation *operation = [[PLOpenRedEnvelopOperation alloc] initWithRedEnvelopParam:mgrParams delay:configDelaySeconds];
            
            if ([PLConfig sharedConfig].serialReceive) {
                [[PLOpenRedEnvelopTaskManager sharedManager] addSerialTask:operation];
            } else {
                [[PLOpenRedEnvelopTaskManager sharedManager] addNormalTask:operation];
            }
            
        }
            // 发红包
    }else{
        
        
        
        switch(arg1.cgiCmdid){
            case 0:
                NSLog(@"预生成红包信息");
                break;
            case 1:
                NSLog(@"生成红包订单");
                break;
            case 5:
                NSLog(@"查询红包领取详情");
                break;
                
                
                
        }
        
        
        
        NSString *requestString = [[NSString alloc] initWithData:arg2.reqText.buffer encoding:NSUTF8StringEncoding];
        
        NSDictionary *requestDictionary = [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:requestString separator:@"&"];
        
        NSDictionary *responseDict = [[[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding] JSONDictionary];
        
        NSLog(@"requestString = %@",requestDictionary);
        NSLog(@"responseDict = %@",responseDict);
        
        
        
    }
    
}

CHOptimizedMethod(1,self,void,WCRedEnvelopesLogicMgr,QueryRedEnvelopesDetailRequest,id,arg1){
    
    CHLog(@"[[### WCRedEnvelopesLogicMgr-QueryRedEnvelopesDetailRequest ###] arg1[class=%@]=%@", [arg1 class], arg1);
    CHSuper(1,WCRedEnvelopesLogicMgr, QueryRedEnvelopesDetailRequest,arg1);
    
    
}


CHDeclareClass(CMessageMgr)

CHOptimizedMethod(2,self,void,CMessageMgr, AsyncOnAddMsg,NSString *,msg,MsgWrap,CMessageWrap*,wrap){
    CHSuper(2,CMessageMgr, AsyncOnAddMsg, msg, MsgWrap, wrap);
    
    CHLog(@"[[### CMessageMgr-AsyncOnAddMsg ###] %@,%@",msg,wrap.m_nsContent);
    switch(wrap.m_uiMessageType) {
        case 49: { // AppNode
            
            /** 是否为红包消息 */
            BOOL (^isRedEnvelopMessage)(void) = ^BOOL() {
                return [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound;
            };
            
            if (isRedEnvelopMessage()) { // 红包
                
                CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
                CContact *selfContact = [contactManager getSelfContact];
                
                NSLog(@"发送者：%@ ------ 接受者:%@ ----- 我自己:%@",wrap.m_nsFromUsr,wrap.m_nsToUsr,selfContact.m_nsUsrName);
                
                BOOL (^isSender)(void) = ^BOOL() {
                    return [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];
                };
                
                /** 是否别人在群聊中发消息 */
                BOOL (^isGroupReceiver)(void) = ^BOOL() {
                    return [wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound;
                };
                
                /** 是否自己在群聊中发消息 */
                BOOL (^isGroupSender)(void) = ^BOOL() {
                    return isSender() && [wrap.m_nsToUsr rangeOfString:@"chatroom"].location != NSNotFound;
                };
                
                /** 是否抢自己发的红包 */
                BOOL (^isReceiveSelfRedEnvelop)(void) = ^BOOL() {
                    return [PLConfig sharedConfig].receiveSelfRedEnvelop;
                };
                
                /** 是否在黑名单中 */
                BOOL (^isGroupInBlackList)(void) = ^BOOL() {
                    return [[PLConfig sharedConfig].blackList containsObject:wrap.m_nsFromUsr];
                };
                
                /** 是否自动抢红包 */
                BOOL (^shouldReceiveRedEnvelop)(void) = ^BOOL() {
                    if (![PLConfig sharedConfig].autoReceiveEnable) { return NO; }
                    if (isGroupInBlackList()) { return NO; }
                    
                    return isGroupReceiver() || (isGroupSender() && isReceiveSelfRedEnvelop());
                };
                
                NSDictionary *(^parseNativeUrl)(NSString *nativeUrl) = ^(NSString *nativeUrl) {
                    nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                    return [objc_getClass("WCBizUtil") dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                };
                
                
                /** 获取服务端验证参数 */
                void (^queryRedEnvelopesReqeust)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    NSMutableDictionary *params = [@{} mutableCopy];
                    
                    /*
                     {
                     agreeDuty = 0;
                     channelId = 1;
                     inWay = 0;
                     msgType = 1;
                     nativeUrl = "wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=1&channelid=1&sendid=1000039501201708037015901599357&sendusername=wxid_3353523535112&ver=6&sign=8b34d48f6cfc5531a3efd5276086df55b9c888ee159eeb50bbed41d81371a8fbfb531cca22bff7c3729c480863c3824d66e5b39ad32d901e513afb5ae00e233e3734e354c00ebbe37119a5d9094a9a84452309242a9544f37404be2c50b8f0e5";
                     sendId = 1000039501201708037015901599357;
                     }
                     
                     */
                    params[@"agreeDuty"] = @"0";
                    params[@"channelId"] = [nativeUrlDict stringForKey:@"channelid"];
                    params[@"inWay"] = @"0";
                    params[@"msgType"] = [nativeUrlDict stringForKey:@"msgtype"];
                    params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    params[@"sendId"] = [nativeUrlDict stringForKey:@"sendid"];
                    
                    WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
                    [logicMgr ReceiverQueryRedEnvelopesRequest:params];
                };
                
                /** 储存参数 */
                void (^enqueueParam)(NSDictionary *nativeUrlDict) = ^(NSDictionary *nativeUrlDict) {
                    
                    /*
                     {
                     channelId = 1;
                     headImg = "http://wx.qlogo.cn/mmhead/ver_1/EScyY63MABNecjZmLczqicspaicsH1uiax92S2nGZmkDeVMURBFTPJhkvRjlLyicicSe5EjNTn8diarkgSZxyp9IyWzSNOAvbxibcmiaa6ZpNRo2zzw/132";
                     msgType = 1;
                     nativeUrl = "wxpay://c2cbizmessagehandler/hongbao/receivehongbao?msgtype=1&channelid=1&sendid=1000039501201708037015901599357&sendusername=wxid_3353523535112&ver=6&sign=8b34d48f6cfc5531a3efd5276086df55b9c888ee159eeb50bbed41d81371a8fbfb531cca22bff7c3729c480863c3824d66e5b39ad32d901e513afb5ae00e233e3734e354c00ebbe37119a5d9094a9a84452309242a9544f37404be2c50b8f0e5";
                     nickName = "Pillar ho";
                     sendId = 1000039501201708037015901599357;
                     sessionUserName = "7510898852@chatroom";
                     
                     // 注意这个
                     timingIdentifier = 4F8E22D5A45EF3EC6CF4323F336CE78D;
                     }
                     
                     */
                    
                    
                    PLOpenRedEnvelopParam *mgrParams = [[PLOpenRedEnvelopParam alloc] init];
                    mgrParams.msgType = [nativeUrlDict stringForKey:@"msgtype"];
                    mgrParams.sendId = [nativeUrlDict stringForKey:@"sendid"];
                    mgrParams.channelId = [nativeUrlDict stringForKey:@"channelid"];
                    mgrParams.nickName = [selfContact getContactDisplayName];
                    mgrParams.headImg = [selfContact m_nsHeadImgUrl];
                    mgrParams.nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                    mgrParams.sessionUserName = isGroupSender() ? wrap.m_nsToUsr : wrap.m_nsFromUsr;
                    mgrParams.sign = [nativeUrlDict stringForKey:@"sign"];
                    
                    mgrParams.isGroupSender = isGroupSender();
                    
                    [[PLOpenRedEnvelopParamQueue sharedQueue] enqueue:mgrParams];
                };
                
                if (shouldReceiveRedEnvelop()) {
                        // 获取红包url
                    NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                        // 解析红包参数
                    NSDictionary *nativeUrlDict = parseNativeUrl(nativeUrl);
                        // 向服务器发送红包验证
                    queryRedEnvelopesReqeust(nativeUrlDict);
                        // 将红包加入队列
                    enqueueParam(nativeUrlDict);
                }
            }
            break;
        }
        default:
            break;
    }
    
}

CHConstructor{
    CHLoadLateClass(CMessageMgr);
    CHClassHook(2, CMessageMgr, AsyncOnAddMsg,MsgWrap);
    CHLoadLateClass(WCRedEnvelopesLogicMgr);
    CHClassHook(2, WCRedEnvelopesLogicMgr, OnWCToHongbaoCommonResponse,Request);
    CHClassHook(1,WCRedEnvelopesLogicMgr,QueryRedEnvelopesDetailRequest);

}
