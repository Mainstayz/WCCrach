//
//  PLSendRedEnvelopParamQueue.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLSendRedEnvelopOperation;
@interface PLSendRedEnvelopParamQueue : NSObject

+ (instancetype)sharedQueue;

- (void)enqueue:(PLSendRedEnvelopOperation *)operation;
- (PLSendRedEnvelopOperation *)getOperationWithOsskey:(NSString *)osskey;
- (PLSendRedEnvelopOperation *)dequeue;
- (PLSendRedEnvelopOperation *)peek;
- (BOOL)isEmpty;
@end
