//
//  PLSendRedEnvelopParam.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSendRedEnvelopParam.h"

@implementation PLSendRedEnvelopParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.perValue = @"1";
        self.totalAmount = @"1";
        self.totalNum = @"1";
        self.hbType = @"0";
        self.wishing = @"傻子才点开红包呢";
    }
    return self;
}

- (NSDictionary *)toParams {
    return @{
             @"perValue": self.perValue,
             @"totalAmount": self.totalAmount,
             @"totalNum": self.totalNum,
             @"hbType": self.hbType,
             @"wishing": self.wishing
            };
}
+ (instancetype)sendRedEnvelopParamfromDic:(NSDictionary *)dic{
    PLSendRedEnvelopParam *params = [[PLSendRedEnvelopParam alloc] init];
    params.perValue = dic[@"perValue"];
    params.totalAmount = dic[@"totalAmount"];
    params.totalNum = dic[@"totalNum"];
    params.hbType = dic[@"hbType"];
    params.wishing = dic[@"wishing"];
    return params;
}


+ (void)update:(PLSendRedEnvelopParam *)param{
    NSDictionary *paramDic = [param toParams];
    [[NSUserDefaults standardUserDefaults] setObject:paramDic forKey:@"sendParam"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (PLSendRedEnvelopParam *)getParam{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendParam"];
    if (dic) {
        return [PLSendRedEnvelopParam sendRedEnvelopParamfromDic:dic];
    }else{
        
        return [[PLSendRedEnvelopParam alloc] init];
    }
}
@end
