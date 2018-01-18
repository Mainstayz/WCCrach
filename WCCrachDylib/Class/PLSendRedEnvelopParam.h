//
//  PLSendRedEnvelopParam.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLSendRedEnvelopParam : NSObject
@property (copy, nonatomic) NSString *perValue;
@property (copy, nonatomic) NSString *totalAmount;
@property (copy, nonatomic) NSString *totalNum;
@property (copy, nonatomic) NSString *hbType; // 1 是拼手气红包   0 是固定金额
@property (copy, nonatomic) NSString *wishing;
+ (instancetype)sendRedEnvelopParamfromDic:(NSDictionary *)dic;
- (NSDictionary *)toParams;


+ (void)update:(PLSendRedEnvelopParam *)param;
+ (PLSendRedEnvelopParam *)getParam;

@end
