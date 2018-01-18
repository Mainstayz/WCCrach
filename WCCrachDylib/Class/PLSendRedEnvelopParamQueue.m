//
//  PLSendRedEnvelopParamQueue.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSendRedEnvelopParamQueue.h"
#import "HeaderForWeChat.h"
#import "PLSendRedEnvelopOperation.h"
@interface PLSendRedEnvelopParamQueue ()

@property (strong, nonatomic) NSMutableArray *queue;

@end

@implementation PLSendRedEnvelopParamQueue
+ (instancetype)sharedQueue {
    static PLSendRedEnvelopParamQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[PLSendRedEnvelopParamQueue alloc] init];
    });
    return queue;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)enqueue:(PLSendRedEnvelopOperation *)operation {
    [self.queue addObject:operation];
}

- (PLSendRedEnvelopOperation *)dequeue {
    if (self.queue.count == 0 && !self.queue.firstObject) {
        return nil;
    }
    
    PLSendRedEnvelopOperation *first = self.queue.firstObject;
    
    [self.queue removeObjectAtIndex:0];
    
    return first;
}

- (PLSendRedEnvelopOperation *)peek {
    if (self.queue.count == 0) {
        return nil;
    }
    
    return self.queue.firstObject;
}

- (BOOL)isEmpty {
    return self.queue.count == 0;
}
- (PLSendRedEnvelopOperation *)getOperationWithOsskey:(NSString *)osskey{
    PLSendRedEnvelopOperation *target = nil;
    for (PLSendRedEnvelopOperation *operation in self.queue) {
        WCRedEnvelopesSendControlLogic *logic = operation.logic;
        WCRedEnvelopesControlData *data = [logic getData];
        NSString *key = [[data m_structDicRedEnvelopesUserInfo][@"operationNext"][@"ossKey"] stringValue];
        if ([osskey isEqualToString:key]) {
            target = operation;
            break;
        }
        
    }
    
    if (target != nil) {
        [self.queue removeObject:target];
    }
    return target;
}
@end
