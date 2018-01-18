//
//  KeepCalmViewController.h
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderForWeChat.h"
@interface KeepCalmViewController : UIViewController
@property (nonatomic, strong) MMTableViewInfo *tableViewInfo;

- (void)startLoadingBlocked;
- (void)startLoadingNonBlock;
- (void)startLoadingWithText:(NSString *)text;
- (void)stopLoading;
- (void)stopLoadingWithFailText:(NSString *)text;
- (void)stopLoadingWithOKText:(NSString *)text;


- (MMTableViewSectionInfo *)tableViewSectionInfoDefaut;
- (MMTableViewSectionInfo *)tableViewSectionInfoHeader:(NSString *)header;
- (MMTableViewSectionInfo *)tableViewSectionInfoHeader:(NSString *)header Footer:(NSString *)footer;

- (MMTableViewCellInfo *)creatNormalCellForSel:(SEL)sel target:(id)target title:(NSString *)title rightValue:(NSString *)rightValue accessoryType:(NSInteger)type;
- (MMTableViewCellInfo *)creatNormalCellForSel:(SEL)sel target:(id)target title:(NSString *)title accessoryType:(NSInteger)type;
- (MMTableViewCellInfo *)creatSwitchCellForSel:(SEL)sel target:(id)target title:(NSString *)title on:(BOOL)on;
- (MMTableViewCellInfo *)creatEditorCellForSel:(SEL)arg1 target:(id)arg2 title:(NSString *)arg3  margin:(double)arg4 tip:(NSString *)tip focus:(BOOL)focus autoCorrect:(BOOL)autoCorrect text:(NSString*)text;
@end
