//
//  PLSendRedEnvelopTaskManager.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PLSendRedEnvelopOperation,CContact,PLSendRedEnvelopParam,WCRedEnvelopesSendControlLogic;
@interface PLSendRedEnvelopTaskManager : NSObject
@property (weak, nonatomic) CContact *chatContact;
+ (instancetype)sharedManager;
- (void)addNormalTask:(PLSendRedEnvelopOperation *)task;
- (void)addSerialTask:(PLSendRedEnvelopOperation *)task;
- (BOOL)serialQueueIsEmpty;

@end
