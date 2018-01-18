//
//  PLOpenRedEnvelopTaskManager.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PLOpenRedEnvelopOperation;
@interface PLOpenRedEnvelopTaskManager : NSObject

+ (instancetype)sharedManager;

- (void)addNormalTask:(PLOpenRedEnvelopOperation *)task;
- (void)addSerialTask:(PLOpenRedEnvelopOperation *)task;

- (BOOL)serialQueueIsEmpty;
@end
