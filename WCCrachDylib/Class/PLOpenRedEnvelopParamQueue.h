//
//  PLOpenRedEnvelopParamQueue.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLOpenRedEnvelopParam;
@interface PLOpenRedEnvelopParamQueue : NSObject

+ (instancetype)sharedQueue;

- (void)enqueue:(PLOpenRedEnvelopParam *)param;
- (PLOpenRedEnvelopParam *)dequeue;
- (PLOpenRedEnvelopParam *)peek;
- (BOOL)isEmpty;
@end
