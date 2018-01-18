//
//  PLSendViewController.m
//  WeChatPlugIn
//
//  Created by Pillar on 2017/8/10.
//  Copyright © 2017年 unkown. All rights reserved.
//

#import "PLSendViewController.h"
#import "PLSendRedEnvelopParam.h"
#import "PLConfig.h"
@interface PLSendViewController ()
@property (nonatomic, strong) PLSendRedEnvelopParam *param;

@end

@implementation PLSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.title = @"Send";
    MMTableView *tableView = [self.tableViewInfo getTableView];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    self.param = [PLSendRedEnvelopParam getParam];
    
    [self reloadData];
}

- (void)reloadData{
    [self.tableViewInfo clearAllSection];
    
    
    MMTableViewSectionInfo* section = [self tableViewSectionInfoDefaut];
    
    BOOL autoMake = [PLConfig sharedConfig].autoMake;
    MMTableViewCellInfo *autoGenCell = [self creatSwitchCellForSel:@selector(switchAutoGenerate:) target:self title:@"Auto generate Red Envelop" on:[PLConfig sharedConfig].autoMake];
    [section addCell:autoGenCell];
    if (autoMake) {
        
        NSString *amount = nil;
        
        if (self.param.totalAmount.length) {
            amount = [NSString stringWithFormat:@"%.2f",([self.param.totalAmount doubleValue] / 100.0)];
        }else{
            amount = @"";
        }
        
        MMTableViewCellInfo *cell = [self creatEditorCellForSel:@selector(totalAmountChange:) target:self title:@"Total Amount:" margin:120 tip:@"¥" focus:NO autoCorrect:YES text:amount];
        [section addCell:cell];
        
        
        MMTableViewCellInfo *cell1 = [self creatEditorCellForSel:@selector(totalNumChange:) target:self title:@"Total Num:" margin:120 tip:@"" focus:NO autoCorrect:YES text:self.param.totalNum?:@""];
        [section addCell:cell1];
        
        MMTableViewCellInfo *cell2 = [self creatEditorCellForSel:@selector(wishingChange:) target:self title:@"Wishing:" margin:120 tip:@"" focus:NO autoCorrect:YES text:self.param.wishing?:@""];
        [section addCell:cell2];
        
        
        MMTableViewCellInfo *cell3 = [self creatSwitchCellForSel:@selector(isRandom:) target:self title:@"Is Random?" on:[self.param.hbType isEqualToString:@"1"]?YES:NO];
        [section addCell:cell3];

        
    }
    
    [self.tableViewInfo addSection:section];
    
    
    MMTableViewSectionInfo *section1 = [self tableViewSectionInfoDefaut];
    MMTableViewCellInfo *passwordCell = [self creatEditorCellForSel:@selector(pwdChange:) target:self title:@"Password:" margin:120 tip:@"" focus:NO autoCorrect:YES text:[PLConfig sharedConfig].pwd?:@""];
    [passwordCell addUserInfoValue:@(YES) forKey:@"secureTextEntry"];
    [section1 addCell:passwordCell];
    
    [self.tableViewInfo addSection:section1];
    

    if ([PLConfig sharedConfig].pwd.length) {
        
        MMTableViewSectionInfo *section2 = [self tableViewSectionInfoDefaut];
        MMTableViewCellInfo *autoPay = [self creatSwitchCellForSel:@selector(switchAutoPay:) target:self title:@"Auto Pay:" on:[PLConfig sharedConfig].autoPay];
        [section2 addCell:autoPay];
        [self.tableViewInfo addSection:section2];

    }
 
    MMTableView *tableView = [self.tableViewInfo getTableView];
    [tableView reloadData];
}


- (void)switchAutoGenerate:(UISwitch *)sender{
    
    [PLConfig sharedConfig].autoMake = sender.on;
    [self reloadData];
}

- (void)switchAutoPay:(UISwitch *)sender{
    if (sender.on == NO) {
        [PLConfig sharedConfig].autoPay = NO;
        [PLConfig sharedConfig].pwd = @"";
        [self reloadData];
        return;
    }
    
    if ([PLConfig sharedConfig].pwd.length != 6 && sender.on == YES) {
        [sender setOn:NO animated:YES];
        [PLConfig sharedConfig].autoPay = NO;
        [PLConfig sharedConfig].pwd = @"";
        [self reloadData];
        return;
    }
    
    [PLConfig sharedConfig].autoPay = sender.on;
    [self reloadData];
}

- (void)totalAmountChange:(UITextField *)sender{
    NSString *amount = [NSString stringWithFormat:@"%d",(int)([sender.text doubleValue]*100)];
    self.param.totalAmount = amount;
    self.param.perValue = amount;
    [PLSendRedEnvelopParam update:self.param];
}

- (void)totalNumChange:(UITextField *)sender{
    NSString *num = [NSString stringWithFormat:@"%d",(int)([sender.text intValue])];
    self.param.totalNum = num;
    [PLSendRedEnvelopParam update:self.param];
}
- (void)isRandom:(UISwitch *)sender{
    NSString *random = [NSString stringWithFormat:@"%d",sender.on];
    self.param.hbType = random;
    [PLSendRedEnvelopParam update:self.param];
}

- (void)wishingChange:(UITextField *)sender{
    NSString *wishing = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.param.wishing = wishing;
    [PLSendRedEnvelopParam update:self.param];
}
- (void)pwdChange:(UITextField *)sender{
    [self startLoadingBlocked];
    NSString* pwd = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (pwd.length == 6 && [self isPureInt:pwd]) {
        [PLConfig sharedConfig].pwd =  [NSString stringWithFormat:@"%ld",[pwd integerValue]];
        [self stopLoading];
    }else{
        [self stopLoadingWithFailText:@"Invalid format!"];
        sender.text = @"";
        [PLConfig sharedConfig].pwd = @"";
        [PLConfig sharedConfig].autoPay = NO;
    }
    [self reloadData];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    
    CGRect firstResponderRect = [firstResponder.superview.superview convertRect:firstResponder.frame toView:self.view];
    
    CGFloat distance = firstResponderRect.origin.y + firstResponderRect.size.height;
    
    if (distance <= keyboardTop) {
        return;
    }
    
    
    
    CGRect newTableViewFrame = self.tableViewInfo.getTableView.frame;
    newTableViewFrame.origin.y -= distance - keyboardTop;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.tableViewInfo.getTableView.frame = newTableViewFrame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.tableViewInfo.getTableView.frame = self.view.bounds;
    
    [UIView commitAnimations];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
