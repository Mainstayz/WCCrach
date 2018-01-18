//
//  PLSettingViewController.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/5.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSettingViewController.h"
#import "PLRobViewController.h"
#import "PLSendViewController.h"
#import "PLConfig.h"
#import "PLMsgConfigureViewController.h"

@interface PLSettingViewController ()
@end

@implementation PLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Low Key";
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [self.view addSubview:tableView];
    MMTableViewSectionInfo *sectionInfo = [self tableViewSectionInfoDefaut];
    MMTableViewCellInfo *cell = [self creatNormalCellForSel:@selector(robRedEnvelopeSetting) target:self title:@"Rob" accessoryType:1];
    [sectionInfo addCell:cell];
    
    
    
    MMTableViewCellInfo *cell1 = [self creatNormalCellForSel:@selector(sendRedEnvelopeSetting) target:self title:@"Send" accessoryType:1];
    [sectionInfo addCell:cell1];

    
    MMTableViewCellInfo *cell2 = [self creatNormalCellForSel:@selector(msgConfigure) target:self title:@"Msg" accessoryType:1];
    [sectionInfo addCell:cell2];
    
    
    MMTableViewCellInfo *cell3 = [self creatEditorCellForSel:@selector(handleStepCount:) target:self title:@"Step count:" margin:140 tip:nil focus:nil autoCorrect:YES text:[NSString stringWithFormat:@"%ld",[PLConfig sharedConfig].stepCount]];
    [sectionInfo addCell:cell3];
    
    
    
    if ([PLConfig sharedConfig].inputLimitEmotionBufSize == 0) {
        [PLConfig sharedConfig].inputLimitEmotionBufSize = 1;
    }
    MMTableViewCellInfo *cell4 = [self creatEditorCellForSel:@selector(handleInputLimitEmotionBufSize:) target:self title:@"Emotion Buf Size:" margin:140 tip:@"M" focus:nil autoCorrect:YES text:[NSString stringWithFormat:@"%ld",[PLConfig sharedConfig].inputLimitEmotionBufSize]];
    [sectionInfo addCell:cell4];

    
    [self.tableViewInfo addSection:sectionInfo];
    [tableView reloadData];
}
- (void)handleStepCount:(UITextField *)sender
{
    [PLConfig sharedConfig].stepCount = sender.text.integerValue;
    [PLConfig sharedConfig].lastChangeStepCountDate = [NSDate date];
    
}


- (void)robRedEnvelopeSetting{
    PLRobViewController *rob = [[PLRobViewController alloc] init];
    [self.navigationController PushViewController:rob animated:YES];
}
- (void)sendRedEnvelopeSetting{
    PLSendViewController *send = [[PLSendViewController alloc] init];
    [self.navigationController PushViewController:send animated:YES];
}

- (void)msgConfigure{
    PLMsgConfigureViewController *vc = [[PLMsgConfigureViewController alloc] init];
    [self.navigationController PushViewController:vc animated:YES];
}
- (void)handleInputLimitEmotionBufSize:(UITextField *)sender{
     [PLConfig sharedConfig].inputLimitEmotionBufSize = sender.text.integerValue;
}




@end
