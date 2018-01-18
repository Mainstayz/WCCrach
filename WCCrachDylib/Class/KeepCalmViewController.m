//
//  KeepCalmViewController.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "KeepCalmViewController.h"
@interface KeepCalmViewController ()
@property (strong, nonatomic) MMLoadingView *loadingView;
@end

@implementation KeepCalmViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _tableViewInfo = [[objc_getClass("MMTableViewInfo") alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]}];
}

- (void)startLoadingBlocked {
    if (!self.loadingView) {
        self.loadingView = [self createDefaultLoadingView];
        [self.view addSubview:self.loadingView];
    } else {
        [self.view bringSubviewToFront:self.loadingView];
    }
    [self.loadingView setM_bIgnoringInteractionEventsWhenLoading:YES];
    [self.loadingView setFitFrame:1];
    [self.loadingView startLoading];
}

- (void)startLoadingNonBlock {
    if (!self.loadingView) {
        self.loadingView = [self createDefaultLoadingView];
        [self.view addSubview:self.loadingView];
    } else {
        [self.view bringSubviewToFront:self.loadingView];
    }
    [self.loadingView setM_bIgnoringInteractionEventsWhenLoading:NO];
    [self.loadingView setFitFrame:1];
    [self.loadingView startLoading];
}

- (void)startLoadingWithText:(NSString *)text {
    [self startLoadingNonBlock];
    
    [self.loadingView.m_label setText:text];
}

- (MMLoadingView *)createDefaultLoadingView {
    MMLoadingView *loadingView = [[objc_getClass("MMLoadingView") alloc] init];
    
    MMServiceCenter *serviceCenter = [objc_getClass("MMServiceCenter") defaultCenter];
    MMLanguageMgr *languageMgr = [serviceCenter getService:objc_getClass("MMLanguageMgr")];
    NSString *loadingText = [languageMgr getStringForCurLanguage:@"Common_DefaultLoadingText" defaultTo:@"Common_DefaultLoadingText"];
    
    [loadingView.m_label setText:loadingText];
    
    return loadingView;
}

- (void)stopLoading {
    [self.loadingView stopLoading];
}

- (void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    MMTableView *tableView = [self.tableViewInfo getTableView];
    tableView.contentInset = self.view.safeAreaInsets;
    tableView.scrollIndicatorInsets = self.view.safeAreaInsets;
}

- (void)stopLoadingWithFailText:(NSString *)text {
    [self.loadingView stopLoadingAndShowError:text];
}

- (void)stopLoadingWithOKText:(NSString *)text {
    [self.loadingView stopLoadingAndShowOK:text];
}

#pragma mark - creat cell

/*
 + (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
 + (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
 + (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
 + (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
 + (id)urlCellForTitle:(id)arg1 url:(id)arg2;
 */
/*
 + (id)sectionInfoDefaut;
 + (id)sectionInfoHeader:(id)arg1;
 + (id)sectionInfoHeader:(id)arg1 Footer:(id)arg2;
 - (void)addCell:(id)arg1;

 */

- (MMTableViewSectionInfo *)tableViewSectionInfoDefaut{
    return [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
}
- (MMTableViewSectionInfo *)tableViewSectionInfoHeader:(NSString *)header{
    return [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:header];
}
- (MMTableViewSectionInfo *)tableViewSectionInfoHeader:(NSString *)header Footer:(NSString *)footer{
    return [objc_getClass("MMTableViewSectionInfo") sectionInfoHeader:header Footer:footer];
}

 
- (MMTableViewCellInfo *)creatNormalCellForSel:(SEL)sel target:(id)target title:(NSString *)title rightValue:(NSString *)rightValue accessoryType:(NSInteger)type{
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:sel target:target title:title rightValue:rightValue accessoryType:type];
}

- (MMTableViewCellInfo *)creatNormalCellForSel:(SEL)sel target:(id)target title:(NSString *)title accessoryType:(NSInteger)type{
    return [objc_getClass("MMTableViewCellInfo") normalCellForSel:sel target:target title:title accessoryType:type];
}

- (MMTableViewCellInfo *)creatSwitchCellForSel:(SEL)sel target:(id)target title:(NSString *)title on:(BOOL)on{
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:sel target:target title:title on:on];
}

- (MMTableViewCellInfo *)creatEditorCellForSel:(SEL)arg1 target:(id)arg2 title:(NSString *)arg3  margin:(double)arg4 tip:(NSString *)tip focus:(BOOL)focus autoCorrect:(BOOL)autoCorrect text:(NSString*)text{
    return [objc_getClass("MMTableViewCellInfo") editorCellForSel:arg1 target:arg2 title:arg3  margin:arg4 tip:tip focus:focus autoCorrect:autoCorrect text:text];
}
@end
