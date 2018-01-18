//
//  PLConfig.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLConfig.h"
#import "HeaderForWeChat.h"

static NSString * const kDelaySecondsKey = @"DelaySecondsKey";
static NSString * const kAutoReceiveRedEnvelopKey = @"WeChatRedEnvelopSwitchKey";
static NSString * const kReceiveSelfRedEnvelopKey = @"ReceiveSelfRedEnvelopKey";
static NSString * const kSerialReceiveKey = @"SerialReceiveKey";
static NSString * const kBlackListKey = @"BlackListKey";
static NSString * const kRevokeEnablekey = @"RevokeEnable";

static NSString * const kAutoMakeKey = @"AutoMakeKey";
static NSString * const kAutoPayKey = @"AutoPayKey";
static NSString * const kPasswordKey = @"PasswordKey";


static NSString * const kStepCount = @"StepCountKey";

static NSString * const kShowMsgInterval = @"ShowMsgIntervalKey";

static NSString * const kLastChangeStepCountDate = @"kLastChangeStepCountDateKey";

static NSString * const kInputLimitEmotionBufSize = @"kInputLimitEmotionBufSizeKey";
@implementation PLConfig
+ (instancetype)sharedConfig {
    static PLConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [PLConfig new];
    });
    return config;
}
- (instancetype)init {
    if (self = [super init]) {
        
        _delaySeconds =  [[NSUserDefaults standardUserDefaults] doubleForKey:kDelaySecondsKey];
        _autoReceiveEnable =  [[NSUserDefaults standardUserDefaults] boolForKey:kAutoReceiveRedEnvelopKey];
        _serialReceive=  [[NSUserDefaults standardUserDefaults] boolForKey:kSerialReceiveKey];
        _blackList = [[NSUserDefaults standardUserDefaults] objectForKey:kBlackListKey];
        _receiveSelfRedEnvelop = [[NSUserDefaults standardUserDefaults] boolForKey:kReceiveSelfRedEnvelopKey];
        _autoMake = [[NSUserDefaults standardUserDefaults] boolForKey:kAutoMakeKey];
        _autoPay = [[NSUserDefaults standardUserDefaults] boolForKey:kAutoPayKey];
        _pwd = [[NSUserDefaults standardUserDefaults] objectForKey:kPasswordKey];
        _revokeEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kRevokeEnablekey];
        _stepCount = [[NSUserDefaults standardUserDefaults] integerForKey:kStepCount];
        _lastChangeStepCountDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastChangeStepCountDate];
        _showMsgInterval = [[NSUserDefaults standardUserDefaults] boolForKey:kShowMsgInterval];
        _inputLimitEmotionBufSize = [[NSUserDefaults standardUserDefaults] integerForKey:kInputLimitEmotionBufSize];
    }
    return self;
}

- (void)setDelaySeconds:(double)delaySeconds {
    _delaySeconds = delaySeconds;
    [[NSUserDefaults standardUserDefaults] setDouble:delaySeconds forKey:kDelaySecondsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAutoReceiveEnable:(BOOL)autoReceiveEnable {
    _autoReceiveEnable = autoReceiveEnable;
    
    [[NSUserDefaults standardUserDefaults] setBool:autoReceiveEnable forKey:kAutoReceiveRedEnvelopKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setReceiveSelfRedEnvelop:(BOOL)receiveSelfRedEnvelop {
    _receiveSelfRedEnvelop = receiveSelfRedEnvelop;
    
    [[NSUserDefaults standardUserDefaults] setBool:receiveSelfRedEnvelop forKey:kReceiveSelfRedEnvelopKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSerialReceive:(BOOL)serialReceive {
    _serialReceive = serialReceive;
    
    [[NSUserDefaults standardUserDefaults] setBool:serialReceive forKey:kSerialReceiveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBlackList:(NSArray *)blackList {
    _blackList = blackList;
    
    [[NSUserDefaults standardUserDefaults] setObject:blackList forKey:kBlackListKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setAutoMake:(BOOL)autoMake{
    _autoMake = autoMake;
    [[NSUserDefaults standardUserDefaults] setBool:autoMake forKey:kAutoMakeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setAutoPay:(BOOL)autoPay{
    _autoPay = autoPay;
    [[NSUserDefaults standardUserDefaults] setBool:autoPay forKey:kAutoPayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPwd:(NSString *)pwd{
    _pwd = pwd;
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:kPasswordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)setRevokeEnable:(BOOL)revokeEnable{
    _revokeEnable = revokeEnable;
    [[NSUserDefaults standardUserDefaults] setBool:revokeEnable forKey:kRevokeEnablekey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setStepCount:(NSInteger)stepCount{
    _stepCount = stepCount;
    [[NSUserDefaults standardUserDefaults] setInteger:stepCount forKey:kStepCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setLastChangeStepCountDate:(NSDate *)lastChangeStepCountDate{
    _lastChangeStepCountDate = lastChangeStepCountDate;
    [[NSUserDefaults standardUserDefaults] setObject:lastChangeStepCountDate forKey:kLastChangeStepCountDate];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)setShowMsgInterval:(BOOL)showMsgInterval{
    _showMsgInterval = showMsgInterval;
    [[NSUserDefaults standardUserDefaults] setBool:showMsgInterval forKey:kShowMsgInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setInputLimitEmotionBufSize:(NSInteger)inputLimitEmotionBufSize{
    if (inputLimitEmotionBufSize == 0) {
        inputLimitEmotionBufSize = 1;
    }
    _inputLimitEmotionBufSize = inputLimitEmotionBufSize;
    [[NSUserDefaults standardUserDefaults] setInteger:inputLimitEmotionBufSize forKey:kInputLimitEmotionBufSize];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
@end
