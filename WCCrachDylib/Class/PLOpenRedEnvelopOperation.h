//
//  PLOpenRedEnvelopOperation.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLOpenRedEnvelopParam;
@interface PLOpenRedEnvelopOperation : NSOperation
- (instancetype)initWithRedEnvelopParam:(PLOpenRedEnvelopParam *)param delay:(double)delaySeconds;
@end
