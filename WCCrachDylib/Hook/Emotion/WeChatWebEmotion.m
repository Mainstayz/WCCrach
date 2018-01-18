//
//  WeChatWebEmotion.m
//  WCCrachDylib
//
//  Created by ZongzhuHe on 2017/11/13.
//  Copyright © 2017年 ZongzhuHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CaptainHook/CaptainHook.h>
#import "HeaderForWeChat.h"
#import "PLConfig.h"


#pragma mark -


CHDeclareClass(MMWebViewController)
CHProperty(MMWebViewController, EmoticonCustomManageAddLogic *, addLogic, setAddLogic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
CHDeclareMethod(2,void, MMWebViewController,AddEmoticonFinishedWithWrap,AddEmoticonWrap *,arg1,IsSuccessed,_Bool,arg2){
    CHLog(@"AddEmoticonFinishedWithWrap agr1 = %@, IsSuccessed %d, %@",arg1,arg2,[NSThread currentThread]);
}



CHDeclareClass(WebviewJSEventHandler_saveImage)
CHOptimizedMethod(0,self, BOOL, WebviewJSEventHandler_saveImage, scanImageBySnapLocation){
    WCActionSheet *sheet = CHIvar(self, m_actionSheet, __strong WCActionSheet *);
    [sheet addButtonWithTitle:@"保存为表情"];
    return CHSuper(0,WebviewJSEventHandler_saveImage, scanImageBySnapLocation);
}

CHOptimizedMethod(2,self, void, WebviewJSEventHandler_saveImage, actionSheet,WCActionSheet*,sheet,clickedButtonAtIndex,NSInteger,index){
    
    CHSuper(2,WebviewJSEventHandler_saveImage, actionSheet,sheet,clickedButtonAtIndex,index);
    NSString *title = [sheet buttonTitleAtIndex:index];
    if ([title isEqualToString:@"保存为表情"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imgUrl = CHIvar(self, m_imgUrl, __strong NSString*);
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
            if (imgData) {
                BOOL isGif = [objc_getClass("CUtility") isGIFFile:imgData];
                if (isGif){
                    NSString *md5 = [objc_getClass("CBaseFile") GetDataMD5:imgData];
                    if ([objc_getClass("EmoticonUtil") saveEmoticonToEmoticonDirForMd5:md5 data:imgData isCleanable:YES]) {
                        CEmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CEmoticonMgr") class]];
                        if ([emoticonMgr CheckEmoticonExistInCustomListByMd5:md5]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [objc_getClass("CControlUtil") showAlert:nil message:@"表情已存在" delegate:nil cancelButtonTitle:nil];
                            });
                            
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                AddEmoticonWrap *wrap = [[objc_getClass("AddEmoticonWrap") alloc] init];
                                wrap.source = 1;
                                wrap.md5 = md5;
                                EmoticonCustomManageAddLogic* addlogic =  [[objc_getClass("EmoticonCustomManageAddLogic") alloc] init];
                                addlogic.delegate = (MMWebViewController *)self.webviewController;
                                [(MMWebViewController *)self.webviewController setAddLogic:addlogic];
                                [addlogic startAddEmoticonWithWrap:wrap];
                                
                            });
                            
                        }
                    }
                }else{
                    UIImage *image = [UIImage imageWithData:imgData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        EmoticonPickViewController *pickViewController = [[objc_getClass("EmoticonPickViewController") alloc] init];
                        pickViewController.m_image = image;
                        MMWebViewController *webViewController =  (MMWebViewController *)self.webviewController;
                        [webViewController.navigationController PushViewController:pickViewController animated:YES];
                    });
                }
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [objc_getClass("CControlUtil") showAlert:nil message:@"图片数据为空" delegate:nil cancelButtonTitle:nil];
                });
            }
        });
        
    }
    
}

CHDeclareClass(EmoticonCustomManageAddLogic)
CHOptimizedMethod(2, self,void,EmoticonCustomManageAddLogic,onAddBackupEmoticonFailed,id,arg1,isOverLimit,_Bool,arg2){
    CHLog(@"onAddBackupEmoticonFailed agr1 = %@, isOverLimit %d, %@",arg1,arg2,[NSThread currentThread]);
    CHSuper(2, EmoticonCustomManageAddLogic,onAddBackupEmoticonFailed,arg1,isOverLimit,arg2);
    
}



CHDeclareClass(MMConfigMgr)

CHOptimizedMethod(0,self, NSInteger,MMConfigMgr,getInputLimitEmotionBufSize){
    
    NSInteger bufSize =  CHSuper(0,MMConfigMgr, getInputLimitEmotionBufSize);
    
    bufSize = bufSize * [PLConfig sharedConfig].inputLimitEmotionBufSize;
    
    return bufSize;
}

CHOptimizedMethod(2, self,void,MMConfigMgr,ReportAddEmoticonWithAddEmoticonWrap,id,arg1,failedReason,id,arg2){
    CHLog(@"ReportAddEmoticonWithAddEmoticonWrap agr1 = %@, failedReason %@, %@",arg1,arg2,[NSThread currentThread]);
    CHSuper(2, MMConfigMgr,ReportAddEmoticonWithAddEmoticonWrap,arg1,failedReason,arg2);
}

CHConstructor{
    
    CHLoadLateClass(WebviewJSEventHandler_saveImage);
    CHClassHook(0,WebviewJSEventHandler_saveImage, scanImageBySnapLocation);
    CHClassHook(2,WebviewJSEventHandler_saveImage, actionSheet,clickedButtonAtIndex);
    
    
    CHLoadLateClass(MMWebViewController);
    CHClassHook(0,MMWebViewController, addLogic);
    CHClassHook(1,MMWebViewController, setAddLogic);
    CHClassHook(2,MMWebViewController,AddEmoticonFinishedWithWrap,IsSuccessed);
    
    CHLoadLateClass(MMConfigMgr);
    CHClassHook(0,MMConfigMgr,getInputLimitEmotionBufSize);
    CHClassHook(2, MMConfigMgr,ReportAddEmoticonWithAddEmoticonWrap,failedReason);
    
    
    CHLoadLateClass(EmoticonCustomManageAddLogic);
    CHClassHook(2,EmoticonCustomManageAddLogic,onAddBackupEmoticonFailed,isOverLimit);
}
