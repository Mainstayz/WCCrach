//
//  PLRobViewController.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/10.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLRobViewController.h"
#import "PLConfig.h"
#import "PLMultiSelectGroupsViewController.h"

@interface PLRobViewController () <UIAlertViewDelegate,MultiSelectGroupsViewControllerDelegate>

@end

@implementation PLRobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Rob";
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
    [self reloadTableView];
    
}

- (void)reloadTableView{
    [self.tableViewInfo clearAllSection];
    [self addBasicSettingSection];
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [tableView reloadData];
}


- (void)addBasicSettingSection {
    MMTableViewSectionInfo *sectionInfo = [objc_getClass("MMTableViewSectionInfo") sectionInfoDefaut];
    [sectionInfo addCell:[self createAutoReceiveRedEnvelopCell]];
    [sectionInfo addCell:[self createDelaySettingCell]];
    [sectionInfo addCell:[self creatReceiveSelfRedEnvelopCell]];
    [sectionInfo addCell:[self creatAsyncReceiveRedEnvelopCell]];
    [sectionInfo addCell:[self creatBlacklistCell]];
    [self.tableViewInfo addSection:sectionInfo];
}



- (MMTableViewCellInfo *)createAutoReceiveRedEnvelopCell {
    return [objc_getClass("MMTableViewCellInfo") switchCellForSel:@selector(switchAutoReceive:) target:self title:@"AutoReceive" on:[PLConfig sharedConfig].autoReceiveEnable];
}
- (void)switchAutoReceive:(UISwitch *)envelopSwitch {
    [PLConfig sharedConfig].autoReceiveEnable = envelopSwitch.on;
    [self reloadTableView];
    
}

- (MMTableViewCellInfo *)createDelaySettingCell {
    double delaySeconds = [PLConfig sharedConfig].delaySeconds;
    NSString *delayString = delaySeconds == 0 ? @"Immediately" : [NSString stringWithFormat:@"%.01f s", delaySeconds];
    
    MMTableViewCellInfo *cellInfo;
    if ([PLConfig sharedConfig].autoReceiveEnable) {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForSel:@selector(settingDelay) target:self title:@"Delay" rightValue: delayString accessoryType:1];
    } else {
        cellInfo = [objc_getClass("MMTableViewCellInfo") normalCellForTitle:@"Delay" rightValue: @"Disable"];
    }
    return cellInfo;
}

- (void)settingDelay {
    UIAlertView *alert = [UIAlertView new];
    alert.title = @"Delay rob (s)";
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Confrim"];
    
    [alert textFieldAtIndex:0].placeholder = @"Delay duration";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *delaySecondsString = [alertView textFieldAtIndex:0].text;
        double delaySeconds = [delaySecondsString doubleValue];
        [PLConfig sharedConfig].delaySeconds = delaySeconds;
        [self reloadTableView];
    }
}

- (MMTableViewCellInfo *)creatReceiveSelfRedEnvelopCell{
    return  [self creatSwitchCellForSel:@selector(switchReceiveSelfRedEnvelop:) target:self title:@"Receive your own red envelope" on:[PLConfig sharedConfig].receiveSelfRedEnvelop];
}
- (void)switchReceiveSelfRedEnvelop:(UISwitch *)sender{
    [PLConfig sharedConfig].receiveSelfRedEnvelop = sender.on;
    [self reloadTableView];
}

- (MMTableViewCellInfo *)creatAsyncReceiveRedEnvelopCell{
    return  [self creatSwitchCellForSel:@selector(switchSerialReceive:) target:self title:@"Serial receive" on:[PLConfig sharedConfig].serialReceive];
}

- (void)switchSerialReceive:(UISwitch *)sender{
    [PLConfig sharedConfig].serialReceive = sender.on;
    [self reloadTableView];
}

- (MMTableViewCellInfo *)creatBlacklistCell{
    NSInteger count = [PLConfig sharedConfig].blackList.count;
    NSString *rightValue = count == 0 ? @"" : [NSString stringWithFormat:@"%ld",(long)count];
    return  [self creatNormalCellForSel:@selector(setupBlacklist) target:self title:@"Blacklist" rightValue:rightValue accessoryType:1];
}

- (void)setupBlacklist{
    PLMultiSelectGroupsViewController *controller = [[PLMultiSelectGroupsViewController alloc] initWithBlackList:[PLConfig sharedConfig].blackList];
    controller.delegate = self;
    [self.navigationController PushViewController:controller animated:YES];
}

- (void)onMultiSelectGroupReturn:(NSArray *)arg1{
    [PLConfig sharedConfig].blackList = arg1;
    [self reloadTableView];
}
- (void)onMultiSelectGroupCancel{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
