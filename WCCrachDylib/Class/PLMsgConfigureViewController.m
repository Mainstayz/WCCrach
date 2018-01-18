//
//  PLMsgConfigureViewController.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/20.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLMsgConfigureViewController.h"
#import "PLConfig.h"

@interface PLMsgConfigureViewController ()

@end

@implementation PLMsgConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Msg";
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
    
    MMTableViewSectionInfo *sectionInfo = [self tableViewSectionInfoDefaut];
    
    MMTableViewCellInfo *cell = [self creatSwitchCellForSel:@selector(interceptRevoke:) target:self title:@"Intercept revoke:" on:[PLConfig sharedConfig].revokeEnable];
    [sectionInfo addCell:cell];
    
    MMTableViewCellInfo *cell1 = [self creatSwitchCellForSel:@selector(messageInterval:) target:self title:@"Message interval:" on:[PLConfig sharedConfig].showMsgInterval];
    [sectionInfo addCell:cell1];
    
    [self.tableViewInfo addSection:sectionInfo];
    [tableView reloadData];
}
- (void)messageInterval:(UISwitch *)sender{
    [PLConfig sharedConfig].showMsgInterval = sender.on;
}

- (void)interceptRevoke:(UISwitch *)sender{
    [PLConfig sharedConfig].revokeEnable = sender.on;
}



@end
