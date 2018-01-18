//
//  WeChatStepNumber.m
//  WCCrachDylib
//
//  Created by ZongzhuHe on 2017/11/13.
//  Copyright © 2017年 ZongzhuHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>
#import "HeaderForWeChat.h"
#import "PLConfig.h"



CHDeclareClass(WCDeviceStepObject)
CHOptimizedMethod0(self, unsigned int, WCDeviceStepObject, m7StepCount)
{
    
    
    if([PLConfig sharedConfig].lastChangeStepCountDate == nil){
        [PLConfig sharedConfig].stepCount = CHSuper0(WCDeviceStepObject, m7StepCount);
        return CHSuper0(WCDeviceStepObject, m7StepCount);
    }
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[PLConfig sharedConfig].lastChangeStepCountDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    BOOL modifyToday = NO;
    if([today isEqualToDate:otherDate]) {
        modifyToday = YES;
    }
    if ([PLConfig sharedConfig].stepCount == 0 || !modifyToday) {
        [PLConfig sharedConfig].stepCount = CHSuper0(WCDeviceStepObject, m7StepCount);
    }
    return (unsigned int)[PLConfig sharedConfig].stepCount;
}

CHConstructor{
    CHLoadLateClass(WCDeviceStepObject);
    CHHook0(WCDeviceStepObject, m7StepCount);
}
