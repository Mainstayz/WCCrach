//
//  PLConfig.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLConfig : NSObject
+ (instancetype)sharedConfig;

@property (assign, nonatomic) BOOL autoReceiveEnable;
@property (assign, nonatomic) double delaySeconds;
@property (assign, nonatomic) BOOL receiveSelfRedEnvelop;
@property (assign, nonatomic) BOOL serialReceive;
@property (strong, nonatomic) NSArray *blackList;

/*Send*/

@property (nonatomic, assign) BOOL autoMake;
@property (nonatomic, assign) BOOL autoPay;
@property (nonatomic, copy) NSString* pwd;

@property (assign, nonatomic) BOOL revokeEnable;

@property (assign, nonatomic) BOOL showMsgInterval;

@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic,retain) NSDate *lastChangeStepCountDate;

@property (nonatomic, assign) NSInteger inputLimitEmotionBufSize;

@end
