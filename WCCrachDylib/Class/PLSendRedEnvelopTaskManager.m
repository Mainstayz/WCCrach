//
//  PLSendRedEnvelopTaskManager.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSendRedEnvelopTaskManager.h"
#import "PLSendRedEnvelopOperation.h"
@interface PLSendRedEnvelopTaskManager ()
@property (strong, nonatomic) NSOperationQueue *normalTaskQueue;
@property (strong, nonatomic) NSOperationQueue *serialTaskQueue;

@end

@implementation PLSendRedEnvelopTaskManager

+ (instancetype)sharedManager{
    static PLSendRedEnvelopTaskManager *taskManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskManager = [PLSendRedEnvelopTaskManager new];
    });
    return taskManager;
}
- (instancetype)init {
    if (self = [super init]) {
        _serialTaskQueue = [[NSOperationQueue alloc] init];
        _serialTaskQueue.maxConcurrentOperationCount = 1;
        
        _normalTaskQueue = [[NSOperationQueue alloc] init];
        _normalTaskQueue.maxConcurrentOperationCount = 5;
    
    }
    return self;
}
- (void)addNormalTask:(PLSendRedEnvelopOperation *)task{
    [self.normalTaskQueue addOperation:task];
    
}
- (void)addSerialTask:(PLSendRedEnvelopOperation *)task{
    [self.serialTaskQueue addOperation:task];
}
- (BOOL)serialQueueIsEmpty{
    return [self.serialTaskQueue operations].count == 0;
}




@end
