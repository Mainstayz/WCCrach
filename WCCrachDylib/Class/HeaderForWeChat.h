//
//  HeaderForWeChat.h
//  WeChat
//
//  Created by Pillar on 2017/8/3.
//  Copyright © 2017年 unkown. All rights reserved.
//

#ifndef HeaderForWeChat_h
#define HeaderForWeChat_h

#import <UIKit/UIKit.h>
#import <objc/objc-runtime.h>

// 支付信息
@interface WCPayInfoItem : NSObject
@property(retain, nonatomic) NSString *m_c2cNativeUrl; // @synthesize m_c2cNativeUrl;
@end

// 消息类
@interface CMessageWrap : NSObject
@property (retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem;
@property(nonatomic) unsigned long m_uiSendTime; // @synthesize m_uiSendTime;
@property(retain, nonatomic) NSString *m_nsRealChatUsr; // 群消息的发信人，具体是群里的哪个人
@property(retain, nonatomic) NSString *m_nsMsgSource; // @synthesize m_nsMsgSource;
@property(retain, nonatomic) NSString *m_nsPushContent; // @synthesize m_nsPushContent;
@property(nonatomic) unsigned long m_uiCreateTime; // @synthesize m_uiCreateTime;
@property(nonatomic) unsigned long m_uiImgStatus; // @synthesize m_uiImgStatus;
@property(nonatomic) unsigned long m_uiStatus; // @synthesize m_uiStatus;
@property(retain, nonatomic) NSString *m_nsContent; // 消息内容;
@property(nonatomic) unsigned long m_uiMessageType; // @synthesize m_uiMessageType;
@property(retain, nonatomic) NSString *m_nsToUsr; // 收信人
@property(retain, nonatomic) NSString *m_nsFromUsr; // 发信人，可能是群或个人
@property(nonatomic) long long m_n64MesSvrID; // @synthesize m_n64MesSvrID;
@property(nonatomic) unsigned long m_uiMesLocalID; // @synthesize m_uiMesLocalID;

- (BOOL)isSentOK;
- (BOOL)IsAtMe;
- (id)keyDescription;
- (BOOL)IsNeedChatExt;
- (id)GetDisplayContent;
- (id)GetMsgClientMsgID;
- (BOOL)IsSameMsgWithFullCheck:(id)arg1;
- (BOOL)IsSameMsg:(id)arg1;
- (BOOL)IsSendBySendMsg;
- (BOOL)IsAppMessage;
- (BOOL)IsShortMovieMsg;
- (BOOL)IsVideoMsg;
- (BOOL)IsImgMsg;
- (BOOL)IsChatRoomMessage;
- (BOOL)IsMassSendMessage;
- (BOOL)IsBottleMessage;
- (BOOL)IsQQMessage;
- (BOOL)IsSxMessage;
- (id)GetChatName;
+ (BOOL)isSenderFromMsgWrap:(id)arg1;
- (id)initWithMsgType:(long long)arg1;
- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap;
@end

// 支付加密类
@interface TenpayPasswordCtrl : UITextField
- (id)GetHashData;
- (id)GetRsaEncryptData;
- (unsigned long long)GetInputLen;
- (void)appendPsw:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1 AndImage:(id)arg2;
@end



// 工具类
@interface WCBizUtil : NSObject

+ (id)dictionaryWithDecodedComponets:(id)arg1 separator:(id)arg2;

@end

// 核心服务类
@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end



@interface MMLanguageMgr: NSObject

- (id)getStringForCurLanguage:(id)arg1 defaultTo:(id)arg2;


@end

#pragma mark - 红包控制类





#pragma mark - HongBaoRes || HongBaoReq

@interface PBGeneratedMessage : NSObject
- (id)baseResponse;
- (BOOL)isInitialized;
@end


@interface SKBuiltinBuffer_t : PBGeneratedMessage
+ (id)skBufferWithData:(id)arg1;
@property(retain, nonatomic) NSData *buffer;
@property(nonatomic) unsigned int iLen;
@end


@interface HongBaoRes : PBGeneratedMessage
@property(nonatomic) int cgiCmdid; // @dynamic cgiCmdid;
@property(retain, nonatomic) NSString *errorMsg; // @dynamic errorMsg;
@property(nonatomic) int errorType; // @dynamic errorType;
@property(retain, nonatomic) NSString *platMsg; // @dynamic platMsg;
@property(nonatomic) int platRet; // @dynamic platRet;
@property(retain, nonatomic) SKBuiltinBuffer_t *retText; // @dynamic retText;
@end

@interface HongBaoReq : PBGeneratedMessage
@property(nonatomic) unsigned int cgiCmd; // @dynamic cgiCmd;
@property(nonatomic) unsigned int outPutType; // @dynamic outPutType;
@property(retain, nonatomic) SKBuiltinBuffer_t *reqText; // @dynamic reqText;
@end

#pragma mark - RedEnvelopesLogicMgr

@interface WCRedEnvelopesLogicMgr : NSObject
- (void)OpenRedEnvelopesRequest:(id)arg1;
- (void)ReceiverQueryRedEnvelopesRequest:(id)arg1;
- (void)GenRedEnvelopesPayRequest:(id)arg1;
- (void)GetHongbaoBusinessRequest:(id)arg1 CMDID:(unsigned int)arg2 OutputType:(unsigned int)arg3;
- (void)OnWCToHongbaoCommonResponse:(HongBaoRes *)arg1 Request:(HongBaoReq *)arg2;
- (void)QueryRedEnvelopesDetailRequest:(id)arg1;
- (double)calculateDelaySeconds;
@end


#pragma mark - Contact

@interface MMService : NSObject
@end

@interface CContactMgr : MMService
- (id)getSelfContact;
- (id)getContactByName:(id)arg1;
- (id)getContactForSearchByName:(id)arg1;
- (_Bool)getContactsFromServer:(id)arg1;
- (_Bool)isInContactList:(id)arg1;
- (_Bool)addLocalContact:(id)arg1 listType:(unsigned int)arg2;

@end


@interface CBaseContact : NSObject
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;
@property(retain, nonatomic) NSString *m_nsUsrName;
@property(retain, nonatomic) NSString *m_nsNickName;
- (id)getContactDisplayUsrName;
- (id)getContactDisplayName;
- (BOOL)isChatroom;
@end

@interface ChatRoomData : NSObject
@end

@interface CContact : CBaseContact
@property (nonatomic, copy) NSString *m_nsChatRoomMemList;
@property (nonatomic, copy) NSString *m_nsChatRoomData;
@property (nonatomic, strong) ChatRoomData *m_ChatRoomData;
+ (id)genChatRoomName:(id)arg1;

@end

@interface WCRedEnvelopesControlData : NSObject
{
    CMessageWrap *m_oSelectedMessageWrap;
    NSDictionary *m_structDicRedEnvelopesBaseInfo;
    NSDictionary *m_structDicRedEnvelopesUserInfo;
}
@property(retain, nonatomic) CMessageWrap *m_oSelectedMessageWrap; // @synthesize m_oSelectedMessageWrap;
@property(retain, nonatomic) NSDictionary *m_structDicRedEnvelopesBaseInfo; // @synthesize
@property(retain, nonatomic) NSDictionary *m_structDicRedEnvelopesUserInfo;
- (void)setM_oSelectContact:(CContact *)contact;
- (void)setM_dicPrepayRequestOrderInfo:(id)arg1;
- (void)setM_structDicPrepayOrderInfo:(id)arg1;
@end


@interface WCRedEnvelopesControlLogic : NSObject
{
    WCRedEnvelopesControlData *m_data;
}
@end

@interface WCRedEnvelopesReceiveControlLogic : WCRedEnvelopesControlLogic
- (void)WCRedEnvelopesReceiveHomeViewOpenRedEnvelopes;
@end



#pragma mark - MMTableView

@interface MMTableViewCellInfo

+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 accessoryType:(long long)arg4;
+ (id)switchCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 on:(_Bool)arg4;
+ (id)normalCellForSel:(SEL)arg1 target:(id)arg2 title:(id)arg3 rightValue:(id)arg4 accessoryType:(long long)arg5;
+ (id)normalCellForTitle:(id)arg1 rightValue:(id)arg2;
+ (id)urlCellForTitle:(id)arg1 url:(id)arg2;
+ (MMTableViewCellInfo *)editorCellForSel:(SEL)arg1 target:(id)arg2 title:(NSString *)arg3  margin:(double)arg4 tip:(NSString *)tip focus:(BOOL)focus autoCorrect:(BOOL)autoCorrect text:(NSString*)text;
- (void)addUserInfoValue:(id)value forKey:(NSString *)key;
@end



@interface MMTableViewSectionInfo

+ (id)sectionInfoDefaut;
+ (id)sectionInfoHeader:(NSString *)arg1;
+ (id)sectionInfoHeader:(NSString *)arg1 Footer:(NSString *)arg2;
- (void)addCell:(MMTableViewCellInfo *)arg1;
- (void)insertCell:(MMTableViewCellInfo *)arg1 At:(NSInteger)index;
- (void)removeCellAt:(NSInteger)index;
- (NSInteger)getCellCount;
- (MMTableViewCellInfo *)getCellAt:(NSInteger)index;
@end
@interface MMTableView: UITableView
- (void)reloadData;
@end

@interface MMTableViewInfo

- (MMTableView *)getTableView;
- (void)clearAllSection;
- (void)addSection:(MMTableViewSectionInfo *)arg1;
- (void)insertSection:(MMTableViewSectionInfo *)arg1 At:(unsigned int)arg2;
- (void)removeSectionAt:(unsigned int)arg1;

@end




#pragma mark - UI
@interface MMUICommonUtil : NSObject

+ (id)getBarButtonWithTitle:(id)arg1 target:(id)arg2 action:(SEL)arg3 style:(int)arg4;

@end

@interface MMLoadingView : UIView

@property(retain, nonatomic) UILabel *m_label; // @synthesize m_label;
@property (assign, nonatomic) BOOL m_bIgnoringInteractionEventsWhenLoading; // @synthesize m_bIgnoringInteractionEventsWhenLoading;

- (void)setFitFrame:(long long)arg1;
- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingAndShowError:(id)arg1;
- (void)stopLoadingAndShowOK:(id)arg1;


@end



@protocol ContactSelectViewDelegate <NSObject>

- (void)onSelectContact:(CContact *)arg1;

@end

@interface ContactSelectView : UIView

@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;
@property(nonatomic) _Bool m_bMultiSelect; // @synthesize m_bMultiSelect;
@property(retain, nonatomic) NSMutableDictionary *m_dicMultiSelect; // @synthesize m_dicMultiSelect;

- (id)initWithFrame:(struct CGRect)arg1 delegate:(id)arg2;
- (void)initData:(unsigned int)arg1;
- (void)initView;
- (void)addSelect:(id)arg1;

@end



@interface ContactsDataLogic : NSObject

@property(nonatomic) unsigned int m_uiScene; // @synthesize m_uiScene;

@end

@interface MMUINavigationController : UINavigationController

@end

@interface MMInputToolView : UIView
- (void)onRedEnvelopesClicked:(id)arg1;
@end



#pragma mark - UtilCategory

@interface NSMutableDictionary (SafeInsert)

- (void)safeSetObject:(id)arg1 forKey:(id)arg2;

@end

@interface NSDictionary (NSDictionary_SafeJSON)

- (id)arrayForKey:(id)arg1;
- (id)dictionaryForKey:(id)arg1;
- (double)doubleForKey:(id)arg1;
- (float)floatForKey:(id)arg1;
- (long long)int64ForKey:(id)arg1;
- (long long)integerForKey:(id)arg1;
- (id)stringForKey:(id)arg1;

@end

@interface NSString (NSString_SBJSON)

- (id)JSONArray;
- (id)JSONDictionary;
- (id)JSONValue;

@end


#pragma mark - UICategory

@interface UINavigationController (LogicController)

- (void)PushViewController:(id)arg1 animated:(_Bool)arg2;

@end



@interface MMUIViewController : UIViewController

- (void)startLoadingBlocked;
- (void)startLoadingNonBlock;
- (void)startLoadingWithText:(NSString *)text;
- (void)stopLoading;
- (void)stopLoadingWithFailText:(NSString *)text;
- (void)stopLoadingWithOKText:(NSString *)text;

@end


@interface NewSettingViewController: MMUIViewController

- (void)jumpSetting;
- (void)reloadTableData;

@end


@interface ContactInfoViewController : MMUIViewController

@property(retain, nonatomic) CContact *m_contact; // @synthesize m_contact;

@end



@protocol MultiSelectContactsViewControllerDelegate <NSObject>
- (void)onMultiSelectContactReturn:(NSArray *)arg1;

@optional
- (int)getFTSCommonScene;
- (void)onMultiSelectContactCancelForSns;
- (void)onMultiSelectContactReturnForSns:(NSArray *)arg1;
@end

@interface MultiSelectContactsViewController : UIViewController

@property(nonatomic) _Bool m_bKeepCurViewAfterSelect; // @synthesize m_bKeepCurViewAfterSelect=_m_bKeepCurViewAfterSelect;
@property(nonatomic) unsigned int m_uiGroupScene; // @synthesize m_uiGroupScene;

@property(nonatomic, weak) id <MultiSelectContactsViewControllerDelegate> m_delegate; // @synthesize m_delegate;

@end

@interface MMMsgLogicManager : NSObject
//(void * self, void * _cmd, void * arg2, void * arg3, char ret_addr, void * arg_4)
- (void)PushLogicControllerByContact:(CContact *)contact navigationController:(id)navigationController animated:(BOOL)animated jumpToLocationNode:(id)node reuse:(BOOL)reuser extraInfo:(id)info;
@end

//-[MMMsgLogicManager PushLogicControllerByContact:navigationController:anim/ated:jumpToLocationNode:reuse:extraInfo:]


#pragma mark -- 发红包

@interface WCPayControlData : NSObject
@end

@interface WCPayPayMoneyLogic : NSObject
- (void)onOrderPayConfirmViewPay:(NSString *)pwd;
@end


@interface BaseChatViewModel : NSObject
@property (readonly, nonatomic) CMessageWrap* messageWrap;
@property (weak, nonatomic) id cellView;
@property (nonatomic) int modelType;
@property (nonatomic) unsigned long splitPosition;
@property (retain, nonatomic) CBaseContact* chatContact;
@property (nonatomic) double createTime;
@property (nonatomic) NSString *intervaleTime;

@end
@interface BaseMessageViewModel : BaseChatViewModel

@end
@interface CommonMessageViewModel : BaseMessageViewModel
{
    CBaseContact *m_contact;
    CMessageWrap *m_messageWrap;
    struct CGSize m_contentViewSize;
    long long m_orientation;
    NSString *m_cpKeyForChatRoomMessage;
    NSString *m_cpKeyForChatRoomDisplayName;
    _Bool m_isChatRoomMessageUnsafe;
    _Bool m_isChatRoomDisplayNameUnsafe;
    _Bool m_isSender;
    _Bool _isShowStatusView;
    _Bool _highlighted;
}

+ (_Bool)canCreateMessageViewModelWithMessageWrap:(id)arg1;
+ (id)createMessageViewModelWithMessageWrap:(id)arg1 contact:(id)arg2 chatContact:(id)arg3;
+ (void)initMessageViewModelClassList;
+ (void)registerMessageViewModelClass:(Class)arg1;
@property(nonatomic) _Bool highlighted; // @synthesize highlighted=_highlighted;
@property(nonatomic) _Bool isShowStatusView; // @synthesize isShowStatusView=_isShowStatusView;
@property(readonly, nonatomic) struct CGSize contentViewSize; // @synthesize contentViewSize=m_contentViewSize;
@property(nonatomic) _Bool isChatRoomDisplayNameUnsafe; // @synthesize isChatRoomDisplayNameUnsafe=m_isChatRoomDisplayNameUnsafe;
@property(nonatomic) _Bool isChatRoomMessageUnsafe; // @synthesize isChatRoomMessageUnsafe=m_isChatRoomMessageUnsafe;
@property(retain, nonatomic) NSString *cpKeyForChatRoomDisplayName; // @synthesize cpKeyForChatRoomDisplayName=m_cpKeyForChatRoomDisplayName;
@property(retain, nonatomic) NSString *cpKeyForChatRoomMessage; // @synthesize cpKeyForChatRoomMessage=m_cpKeyForChatRoomMessage;
@property(readonly, nonatomic) _Bool isSender; // @synthesize isSender=m_isSender;
@property(retain, nonatomic) CMessageWrap *messageWrap; // @synthesize messageWrap=m_messageWrap;
@property(retain, nonatomic) CBaseContact *contact; // @synthesize contact=m_contact;
- (void)onMessageUpdateStatus;
- (id)chatRoomDisplayName;
- (struct CGSize)measureContentViewSize:(struct CGSize)arg1;
- (struct CGSize)measure:(struct CGSize)arg1;
- (void)resetLayoutCache;
- (void)updateContentViewHeight:(double)arg1;
- (_Bool)isShowSendOKView;
- (void)updateCrashProtectedState;
- (id)additionalAccessibilityDescription;
- (id)accessibilityDescription;
- (void)dealloc;
- (id)initWithMessageWrap:(id)arg1 contact:(id)arg2 chatContact:(id)arg3;
@property(readonly, nonatomic) unsigned int msgStatus;

@end

@interface TextMessageViewModel : CommonMessageViewModel
- (NSMutableArray *) subViewModels;
@end

@interface TextMessageSubViewModel : TextMessageViewModel
@property (weak, nonatomic) TextMessageViewModel* parentModel;
@end


@interface BaseMsgContentViewController : UIViewController{
    NSMutableArray *m_arrMessageNodeData;
}
- (CContact *)GetContact;
- (CContact *)GetChatContact;

//首次进入
- (void) initTableView;
// 加载历史消息
- (void) onLoadMoreMessage;
// 添加消息
- (void)addMessageNode:(CMessageWrap *)wrap layout:(BOOL)layout addMoreMsg:(BOOL)addMoreMsg;

- (NSMutableArray *) GetMessagesWrapArray;

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;

- (NSString *)getTimeIntervalDescriptionWithTime:(NSInteger)time;
@end

@interface WeixinContentLogicController : UIViewController
- (CContact *)GetContact;
- (CContact *)GetChatContact;

@end

@interface WCRedEnvelopesSendControlLogic : NSObject{
    WCPayPayMoneyLogic *m_payMoneyLogic;
    WCRedEnvelopesControlData* m_data;
    WCPayControlData *oPayData;
    NSInteger m_scene;
}

- (instancetype)initWithData:(id)arg1;
- (instancetype)initWithData:(id)arg1 Scene:(int)arg2 RedEnvelopesType:(int)arg3;
- (void)startLogic;

- (void)OnQueryRedEnvelopesUserInfo:(id)arg1 Error:(id)arg2;
- (void)OnGenRedEnvelopesPayRequest:(id)arg1 Error:(id)arg2;
- (id)getData;

- (void)OnMakeWCRedEnvelopesButtonClick:(WCRedEnvelopesControlData *)data;
@end


@interface WCRedEnvelopesControlMgr : NSObject
- (void)startLogic:(id)arg1;
@end

@interface MMUIView : UIView

@end
@interface WCPayTenpayPasswordCtrlItem : NSObject{
    TenpayPasswordCtrl* m_textField;
    
}
@end
@interface WCPayOrderPayConfirmView : MMUIView{
    WCPayTenpayPasswordCtrlItem * m_textFieldItemPwd;
}
- (instancetype)initWithFrame:(CGRect)frame andData:(id)data delegate:(id)deletate;
- (void)onPayBtnClick;
- (void)closeView;
- (void)didMoveToWindow;

@end

@interface WCPayControlLogic : NSObject

- (void)showPayOrderConfirmViewWithData:(WCPayControlData *)data delegate:(WCPayPayMoneyLogic *)logic;
@end
@interface WCPayLogicMgr : NSObject
- (void)AuthenticationPay:(id)pwd;
@end

#pragma  mark - CMessageMgr

@interface CMessageMgr : NSObject
- (void)onRevokeMsg:(id)arg1;
- (void)AddLocalMsg:(id)arg1 MsgWrap:(id)arg2 fixTime:(_Bool)arg3 NewMsgArriveNotify:(_Bool)arg4;
@end








@interface BaseChatCellView : UIView

@end
@interface BaseMessageCellView : BaseChatCellView

@end
@interface CommonMessageCellView : BaseMessageCellView{
    UIView *m_contentView;
}
@property (readonly, nonatomic) id viewModel;
@property (nonatomic) UILabel *expandView;
- (void) updateStatus;
- (void) updateNodeStatus;
- (void) initWithViewModel:(id)model;
@end


@interface VoiceMessageCellView : CommonMessageCellView{
    double m_currVoiceTimeLength;
    UILabel *m_secLabel;
}

@end


@interface ChatTableViewCell : UITableViewCell
@property (readonly, nonatomic) id cellView;
@end


#pragma  mark - WCDeviceStepObject

@interface WCDeviceStepObject : NSObject
- (unsigned int)m7StepCount;
@end


@interface ManualAuthAesReqData

-(void)setBundleId:(NSString*) bundleID;

@end

#pragma  mark - SaveImage


@interface WCActionSheet:UIWindow
-(void)showInView:(UIView *)view;
-(NSInteger)addButtonWithTitle:(NSString *)title;
-(NSInteger)addButtonWithTitle:(NSString *)title atIndex:(NSInteger)index;
-(NSString *)buttonTitleAtIndex:(NSInteger)index;

@end



@interface WebviewJSEventHandler_saveImage : NSObject{
    NSString *m_imgUrl;
    WCActionSheet *m_actionSheet;
}
- (id) webviewController;
- (BOOL)scanImageBySnapLocation;
- (void)handleJSEvent:(id)arg1 HandlerFacade:(id)arg2 ExtraData:(id)arg3;
- (void)actionSheet:(WCActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index;

@end




@interface CBaseFile : NSObject
+ (NSString *)GetDataMD5:(NSData *)data;
@end
@interface EmoticonUtil : NSObject
+ (BOOL)saveEmoticonToEmoticonDirForMd5:(NSString *)md5 data:(NSData *)data isCleanable:(BOOL)isCleanable;
+ (id)dataOfEmoticonForMd5:(NSString *)md5;
@end

@interface CEmoticonMgr : NSObject
- (BOOL)CheckEmoticonExistInCustomListByMd5:(NSString *)md5;
+ (void)ReportAddEmoticonWithAddEmoticonWrap:(id)arg1 failedReason:(id)arg2;

@end

@interface CControlUtil : NSObject
+(id)showAlert:(id)alert message:(NSString *)msg delegate:(id)delegate cancelButtonTitle:(NSString *)canceTitle;
@end

@interface EmoticonCustomManageViewController : MMUIViewController
- (void)handleGIFInfo:(NSMutableDictionary *)info;
@end



@interface AddEmoticonWrap : NSObject
@property(nonatomic) long long source; // @synthesize source=_source;
@property(retain, nonatomic) NSString *md5;
@end


@interface EmoticonCustomManageAddLogic : NSObject
@property(nonatomic) id delegate;
- (BOOL)startAddEmoticonWithWrap:(AddEmoticonWrap *)wrap;
- (void)onAddBackupEmoticonFailed:(id)arg1 isOverLimit:(_Bool)arg2;
- (void)onAddBackupEmoticonOK:(id)arg1;

@end

@interface EmoticonPickViewController : UIViewController
@property(retain, nonatomic) UIImage *m_image;
@end

@interface MMWebViewController: MMUIViewController
@property (nonatomic, strong) EmoticonCustomManageAddLogic *addLogic;
- (id)initWithURL:(id)arg1 presentModal:(_Bool)arg2 extraInfo:(id)arg3;
- (void)AddEmoticonFinishedWithWrap:(AddEmoticonWrap *)arg1 IsSuccessed:(_Bool)arg2;
@end


@interface MMConfigMgr: NSObject
- (NSInteger)getInputLimitEmotionBufSize;
@end

@interface CUtility: NSObject
+ (BOOL)isGIFFile:(NSData *)data;
@end


#endif /* HeaderForWeChat_h */
