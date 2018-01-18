//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WCCrachDylib.m
//  WCCrachDylib
//
//  Created by ZongzhuHe on 2017/11/12.
//  Copyright (c) 2017年 ZongzhuHe. All rights reserved.
//

#import "WCCrachDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <Cycript/Cycript.h>
#import "HeaderForWeChat.h"


#import "PLSettingViewController.h"

static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
}


// 设置界面
CHDeclareClass(NewSettingViewController)
CHOptimizedMethod(0,self,void,NewSettingViewController,reloadTableData){
    CHSuper(0,NewSettingViewController, reloadTableData);
    
    MMTableViewInfo *tableViewInfo = CHIvar(self, m_tableViewInfo, __strong MMTableViewInfo *);
    MMTableViewSectionInfo *info = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    MMTableViewCellInfo *cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(jumpSetting) target:self title:@"Low-key" accessoryType:1];
    [info addCell:cellInfo];
    [tableViewInfo insertSection:info At:1];
    
    MMTableView *tableView = [tableViewInfo getTableView];
    [tableView reloadData];
    
}

CHDeclareMethod0(void,NewSettingViewController,jumpSetting){
    
    PLSettingViewController *setting = [[PLSettingViewController alloc] init];
    [self.navigationController PushViewController:setting animated:YES];
}


CHDeclareClass(ManualAuthAesReqData)
CHOptimizedMethod1(self, void, ManualAuthAesReqData, setBundleId, NSString*, bundleId){
    bundleId = @"com.tencent.xin";
    CHSuper1(ManualAuthAesReqData, setBundleId, bundleId);
}
CHConstructor{
    
    
    
    // 设置界面
    CHLoadLateClass(NewSettingViewController);
    CHClassHook0(NewSettingViewController,reloadTableData);
    CHClassHook0(NewSettingViewController,jumpSetting);
    
    // BundleId
    CHLoadLateClass(ManualAuthAesReqData);
    CHClassHook1(ManualAuthAesReqData, setBundleId);
    

}

