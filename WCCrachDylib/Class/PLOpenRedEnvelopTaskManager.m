//
//  PLOpenRedEnvelopTaskManager.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLOpenRedEnvelopTaskManager.h"
#import "PLOpenRedEnvelopOperation.h"

@interface PLOpenRedEnvelopTaskManager ()
@property (strong, nonatomic) NSOperationQueue *normalTaskQueue;
@property (strong, nonatomic) NSOperationQueue *serialTaskQueue;
@end

@implementation PLOpenRedEnvelopTaskManager

+ (instancetype)sharedManager{
    static PLOpenRedEnvelopTaskManager *taskManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        taskManager = [PLOpenRedEnvelopTaskManager new];
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
- (void)addNormalTask:(PLOpenRedEnvelopOperation *)task{
    [self.normalTaskQueue addOperation:task];
    
}
- (void)addSerialTask:(PLOpenRedEnvelopOperation *)task{
    [self.serialTaskQueue addOperation:task];
}
- (BOOL)serialQueueIsEmpty{
    return [self.serialTaskQueue operations].count == 0;
}
@end
