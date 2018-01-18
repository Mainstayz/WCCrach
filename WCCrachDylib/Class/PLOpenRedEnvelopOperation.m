//
//  PLOpenRedEnvelopOperation.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLOpenRedEnvelopOperation.h"
#import "PLOpenRedEnvelopParam.h"
#import "HeaderForWeChat.h"

@class PLOpenRedEnvelopParam;
@interface PLOpenRedEnvelopOperation ()
@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (strong, nonatomic) PLOpenRedEnvelopParam *redEnvelopParam;
@property (assign, nonatomic) double delaySeconds;
@end
@implementation PLOpenRedEnvelopOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRedEnvelopParam:(PLOpenRedEnvelopParam *)param delay:(double)delaySeconds {
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

    if (self.delaySeconds == 0) {
        WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
        [logicMgr OpenRedEnvelopesRequest:[self.redEnvelopParam toParams]];
        self.finished = YES;
        self.executing = NO;
    }else{
        __block PLOpenRedEnvelopOperation*weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
            [logicMgr OpenRedEnvelopesRequest:[weakSelf.redEnvelopParam toParams]];
            weakSelf.finished = YES;
            weakSelf.executing = NO;  
        });
    }
    
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
