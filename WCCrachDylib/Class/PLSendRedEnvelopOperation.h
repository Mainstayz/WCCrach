//
//  PLSendRedEnvelopOperation.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLSendRedEnvelopParam,WCRedEnvelopesSendControlLogic;
@interface PLSendRedEnvelopOperation : NSOperation
@property (nonatomic, strong, readonly) WCRedEnvelopesSendControlLogic *logic;
- (instancetype)initWithRedEnvelopParam:(PLSendRedEnvelopParam *)param delay:(double)delaySeconds;
@end
