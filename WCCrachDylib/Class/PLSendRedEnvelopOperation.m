//
//  PLSendRedEnvelopOperation.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSendRedEnvelopOperation.h"
#import "PLSendRedEnvelopParam.h"
#import "HeaderForWeChat.h"
#import "PLSendRedEnvelopTaskManager.h"
@class PLSendRedEnvelopParam;
@interface PLSendRedEnvelopOperation ()
@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (strong, nonatomic) PLSendRedEnvelopParam *redEnvelopParam;
@property (assign, nonatomic) double delaySeconds;
@property (nonatomic, strong, readwrite) WCRedEnvelopesSendControlLogic *logic;
@end
@implementation PLSendRedEnvelopOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRedEnvelopParam:(PLSendRedEnvelopParam *)param delay:(double)delaySeconds {
    if (self = [super init]) {
        _redEnvelopParam = param;
        _delaySeconds = delaySeconds;
    }
    return self;
}
- (void)start {
    if (self.isCancelled) {
        self.finished = YES;
        self.executing = NO;
        return;
    }
    
    [self main];
    
    self.executing = YES;
    self.finished = NO;
}

- (void)main {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CContact *contact = [PLSendRedEnvelopTaskManager sharedManager].chatContact;
        if (contact != nil) {
            WCRedEnvelopesControlData *data =  [[objc_getClass("WCRedEnvelopesControlData") alloc] init];
            [data setM_oSelectContact:contact];
            NSMutableDictionary *dicPrepayRequestOrderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.redEnvelopParam toParams]];
            dicPrepayRequestOrderInfo[@"username"] = contact.m_nsUsrName;
            
            dicPrepayRequestOrderInfo[@"hbType"] = [contact isChatroom] ? self.redEnvelopParam.hbType : @"0"; // 1 是拼手气红包   0 是固定金额
            dicPrepayRequestOrderInfo[@"totalNum"] =[contact isChatroom]? self.redEnvelopParam.totalNum : @"1";
            [data setM_dicPrepayRequestOrderInfo:dicPrepayRequestOrderInfo];
            int scene = [contact isChatroom] ? 2 : 1;
            WCRedEnvelopesSendControlLogic *logic =  [[objc_getClass("WCRedEnvelopesSendControlLogic") alloc] initWithData:data Scene:scene RedEnvelopesType:0];
            self.logic = logic;
            MMServiceCenter *serviceCenter = [objc_getClass("MMServiceCenter") defaultCenter];
            WCRedEnvelopesControlMgr *mgr = [serviceCenter getService:objc_getClass("WCRedEnvelopesControlMgr")];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [mgr startLogic:logic];
            });
            
        }
        self.finished = YES;
        self.executing = NO;
    });
    
}
- (void)cancel {
    self.finished = YES;
    self.executing = NO;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}
@end
