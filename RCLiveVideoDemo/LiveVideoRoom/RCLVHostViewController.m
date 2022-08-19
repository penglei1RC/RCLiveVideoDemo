//
//  RCLVHostViewController.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVHostViewController.h"
#import "RCLVHostPresenter.h"
#import "RCLVRoomInfoView.h"
#import "RCLVRoomActionView.h"
#import "RCUserListView.h"
#import <RCLiveVideoLib/RCLiveVideoLib.h>
#import "RCLVSeatItemView.h"
#import "RCLVHostViewController+PK.h"
#import "RCLVPresenter+PK.h"
#import "RCLVPKView.h"

@interface RCLVHostViewController ()<RCLiveVideoDelegate,RCLiveVideoMixDelegate,RCLiveVideoMixDataSource,RCLiveVideoPKDelegate>

@property (nonatomic, strong, readwrite) RCLVHostPresenter *presenter;
@property (nonatomic, strong) RCLVRoomInfoView *infoView;
@property (nonatomic, strong) RCLVRoomActionView *actionView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong, readwrite) RCUserListView *userListView;
@property (nonatomic, strong) UIView *seatsView;
@property (nonatomic, strong, readwrite) CreateRoomModel *roomInfo;
@property (nonatomic, strong) RCLVPKView *pkView;

@end

@implementation RCLVHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLiveEngine];
    [self buildLayout];
    
    
    [self.presenter createRoomWithCompletionBlock:^(CreateRoomModel * _Nullable roomInfo) {
        if (!roomInfo) {
            return ;
        }
        
        self.roomInfo = roomInfo;
        [self.infoView updateUIWith:roomInfo];
        [self begin];
    }];
}

- (void)begin {
    [self.presenter beginWithCompletionBlock:^(BOOL success) {
        if (!success) {
            return;
        }
        [self pk_loadPKModule];
    }];
    
}

- (void)configLiveEngine {
    RCRTCEngine.sharedInstance.defaultVideoStream.videoConfig = [self.presenter videoStreamConfig];
    /// 设置代理，接收视频流输出回调
    /// 此时，可以在didOutputSampleBuffer:回调方法里处理视频流，比如：美颜。
    RCLiveVideoEngine.shared.delegate = self;
    RCLiveVideoEngine.shared.mixDelegate = self;
    RCLiveVideoEngine.shared.mixDataSource = self;
    RCLiveVideoEngine.shared.pkDelegate = self;
    
    [RCLiveVideoEngine.shared prepare];
}

- (void)buildLayout {
    [self.view addSubview:self.previewView];
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.view);
        make.width.equalTo(self.previewView.mas_height).multipliedBy(9.0 / 16);
    }];
    
    [self.view addSubview:self.seatsView];
    [self.seatsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.previewView);
    }];
    
    [self.view addSubview:self.pkView];
    [self.pkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.seatsView);
    }];
    
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.top.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.bottom.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    [self.view addSubview:self.userListView];
}

- (void)setupPreviewLayout:(RCLiveVideoMixType)mixType {
    UIView *previewView = RCLiveVideoEngine.shared.previewView;
    switch (mixType) {
        case RCLiveVideoMixTypeDefault:
        case RCLiveVideoMixTypeOneToOne:
        {
            [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(self.view);
                make.width.equalTo(previewView.mas_height).multipliedBy(9.0 / 16);
            }];
        }
            break;
        case RCLiveVideoMixTypeOneToSix:
        {
            [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.view).offset(98);
                make.width.equalTo(self.view).offset(-60);
            }];
        }
            break;
        default:
        {
            [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.view).offset(98);
                make.height.equalTo(self.previewView.mas_width);
            }];
        }
            break;
    }
}

#pragma mark - 房间管理
- (void)fetchRequestList {
    [self.presenter fetchRequestListWithBlock:^(NSArray<UserModel *> * _Nonnull userList) {
        if (!userList) {
            return;
        }
        self.userListView.listType = RCUserListTypeRequest;
        [self.userListView reloadData:userList];
        [self.userListView show];
    }];
}

- (void)fetchInvites {
    [self.presenter fetchInvitationsWithBlock:^(NSArray<UserModel *> * _Nullable userList) {
        if (!userList) {
            return;
        }
        self.userListView.listType = RCUserListTypeRoomInvite;
        [self.userListView reloadData:userList];
        [self.userListView show];
    }];
}

- (void)fetchRoomUsers {
    [self.presenter fetchRoomUserListWithBlock:^(NSArray<UserModel *> * _Nullable userList) {
        if (!userList) {
            return;
        }
        self.userListView.listType = RCUserListTypeRoomUser;
        [self.userListView reloadData:userList];
        [self.userListView show];
    }];
}

- (void)updatePKStatus:(BOOL)isPK {
    self.pkView.hidden = !isPK;
    self.actionView.isPK = isPK;
}

#pragma mark - seat action
- (void)showActionSheetWithSeatInfo:(RCLiveVideoSeat *)seatInfo {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"请选择操作" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"闭麦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter muteSeat:seatInfo mute:!seatInfo.mute];
    }]];
    if ([RCUserManager.uid isEqualToString:seatInfo.userId]) {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"开启/关闭音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.presenter enableAudioSeat:seatInfo userEnableAudio:!seatInfo.userEnableAudio];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"开启/关闭视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.presenter enableVideoSeat:seatInfo userEnableVideo:!seatInfo.userEnableVideo];
        }]];
    }
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"锁麦" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter lockSeat:seatInfo lock:!seatInfo.lock];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"踢出麦位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.presenter kickLiveVideoFromSeat:seatInfo.userId];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - !!! RCLiveVideoDelegate !!!
/// 视频输出回调，可以在此接口做视频流二次开发，例如：美颜。
/// @param frame 视频帧数据
- (RCRTCVideoFrame *)didOutputFrame:(RCRTCVideoFrame *)frame {
    return frame;
}

/// 直播连麦开始，通过申请、邀请等方式成功上麦后，接收回调。
- (void)liveVideoDidBegin:(RCLiveVideoCode)code {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_start_boardcast")];
}

/// 邀请上麦被同意
- (void)liveVideoInvitationDidAccept:(NSString *)invitee {
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_accept_invite"),invitee]];
}

/// 邀请上麦被拒绝
- (void)liveVideoInvitationDidReject:(NSString *)invitee {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_reject_invite"),invitee]];
}

/// 房间连麦用户更新：用户上麦、下麦等
/// @param userIds 连麦的用户
- (void)liveVideoUserDidUpdate:(NSArray<NSString *> *)userIds {
    
}

/// 直播连麦结束
- (void)liveVideoDidFinish:(RCLiveVideoFinishReason)reason {
    
}

/// 上麦申请列表发生变化
- (void)liveVideoRequestDidChange {
    Log(@"HostViewController audience request list had changed");
    [SVProgressHUD showInfoWithStatus:LVSLocalizedString(@"live_request_list_changed")];
    [self fetchRequestList];
}

/// 房间信息更新
/// @param key 房间信息属性
/// @param value 房间信息内容
- (void)roomInfoDidUpdate:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:@"roomNotice"]) {
        [SVProgressHUD showInfoWithStatus:value];
    }
}

/// 房间关闭
- (void)roomDidClosed {
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_end")];
}

/// 视频连麦模式发生变化
/// @param mixType 连麦类型
- (void)roomMixTypeDidChange:(RCLiveVideoMixType)mixType {
    Log(@"mix type did change");
    [self setupPreviewLayout:mixType];
    if (mixType == RCLiveVideoMixTypeGridTwo || mixType == RCLiveVideoMixTypeGridThree) {
        for (RCLiveVideoSeat *seat in RCLiveVideoEngine.shared.currentSeats) {
            /// 控制本端订阅分流时是否采用小流，默认为 YES
            seat.enableTiny = NO;
        }
    }
    for (UIView *subView in self.seatsView.subviews) {
        [subView removeFromSuperview];
    }
}


#pragma mark - RCLiveVideoMixDelegate

/// 自定义麦位视图
/// @param seat 麦位对象
/// @param frame 麦位在 previewView 中的位置
- (void)liveVideoDidLayout:(RCLiveVideoSeat *)seat withFrame:(CGRect)frame {
    if (RCLiveVideoEngine.shared.pkInfo) {
        return ;
    }
    long tag = seat.index + RCLVSeatItemViewTagMask;
    RCLVSeatItemView *oldSeatView = [self.seatsView viewWithTag:tag];
    [oldSeatView removeFromSuperview];
    
    RCLVSeatItemView *newSeatView = [[RCLVSeatItemView alloc] initWithFrame:frame];
    [newSeatView setSeatInfo:seat];
    newSeatView.tag = tag;
    newSeatView.handler = ^() {
        [self showActionSheetWithSeatInfo:seat];
    };
    [self.seatsView addSubview:newSeatView];
}

/// 合流布局配置将要更新
/// 开发者可以在此修改合流配置：
/// 视频：帧率、码率、背景等
/// 音频：码率等
/// @param config 配置对象
- (void)roomMixConfigWillUpdate:(RCRTCMixConfig *)config {
    
}


#pragma mark - RCLiveVideoMixDataSource
/// 合流画布尺寸，使用 RCLiveVideoMixTypeCustom 模式时，必须实现！！！
- (CGSize)liveVideoPreviewSize {
    return CGSizeMake(720, 1280);
}

/// 连麦布局对应的麦位位置数组：Array<CGRect>，使用 RCLiveVideoMixTypeCustom 模式时，必须实现！！！
- (NSArray<NSValue *> *)liveVideoFrames {
    return @[
        @(CGRectMake(0.0000, 0.0000, 0.5000, 1.0000)),
        @(CGRectMake(0.5000, 0.0000, 0.5000, 1.0000)),
    ];
}

#pragma mark - lazy load
- (RCLVHostPresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCLVHostPresenter new];
    }
    return _presenter;
}

- (UIView *)previewView {
    if (!_previewView) {
        _previewView = [RCLiveVideoEngine.shared previewView];
        
    }
    return _previewView;
}

- (UIView *)seatsView {
    if (!_seatsView) {
        _seatsView = [UIView new];
    }
    return _seatsView;
}

- (RCLVRoomInfoView *)infoView {
    if (!_infoView) {
        _infoView = [RCLVRoomInfoView new];
    }
    return _infoView;
}

- (RCLVRoomActionView *)actionView {
    if (!_actionView) {
        _actionView = [[RCLVRoomActionView alloc] initWithTypes:
                       @[@(RCLVRoomActionTypeGetRequestList),
                         @(RCLVRoomActionTypeHostInvite),
                         @(RCLVRoomActionTypeGetRoomUsers),
                         @(RCLVRoomActionTypePK),
                         @(RCLVRoomActionTypeLeaveRoom),
                         @(RCLVRoomActionTypeSetMixType),
                         @(RCLVRoomActionTypeSetNotice)]];
        WeakSelf(self);
        _actionView.hander = ^(RCLVRoomActionType type, BOOL isSelected) {
            StrongSelf(weakSelf);
            switch (type) {
                case RCLVRoomActionTypeGetRequestList:
                    [strongSelf fetchRequestList];
                    break;
                case RCLVRoomActionTypeHostInvite:
                    [strongSelf fetchInvites];
                    break;
                case RCLVRoomActionTypeGetRoomUsers:
                    [strongSelf fetchRoomUsers];
                    break;
                case RCLVRoomActionTypePK:
                    [strongSelf pk_invite:isSelected];
                    break;
                case RCLVRoomActionTypeLeaveRoom:
                    [strongSelf.presenter finish];
                    break;
                case RCLVRoomActionTypeSetMixType:
                    [strongSelf.presenter setMixType:RCLiveVideoMixTypeGridThree];
                    break;
                case RCLVRoomActionTypeSetNotice:
                    [strongSelf.presenter updateRoomInfo:@{@"roomNotice":@"公告来啦～"}];
                    break;
                default:
                    break;
            }
        };
    }
    return _actionView;
}

- (RCUserListView *)userListView {
    if (!_userListView) {
        _userListView = [[RCUserListView alloc] initWithCreate:YES];
        _userListView.frame = CGRectMake(10, kScreenHeight, kScreenWidth - 20, kScreenHeight - 300);
        WeakSelf(self);
        _userListView.handler = ^(NSString * _Nonnull uid, NSString * _Nullable roomId, RCUserListCellActionType type) {
            StrongSelf(weakSelf);
            switch (type) {
                case RCUserListCellActionTypeAgree:
                    [strongSelf.presenter acceptRequest:uid];
                    break;
                case RCUserListCellActionTypeReject:
                    [strongSelf.presenter rejectRequest:uid];
                    break;
                case RCUserListCellActionTypeInvite:
                    [strongSelf.presenter inviteLiveVideo:uid];
                    break;
                case RCUserListCellActionTypeCancelInvite:
                    [strongSelf.presenter cancelInviteLiveVideo:uid];
                    break;
                case RCUserListCellActionTypeKick:
                    [strongSelf.presenter kickOutRoom:uid];
                    break;
                case RCUserListCellActionTypePKInvite:
                    [strongSelf.presenter pk_sendPKInvitation:roomId invitee:uid];
                    break;
                case RCUserListCellActionTypePKCancel:
                    [strongSelf.presenter pk_cancelPKInvitation:roomId invitee:uid];
                    break;
                    
                default:
                    break;
            }
        };
    }
    return _userListView;
}

- (RCLVPKView *)pkView {
    if (!_pkView) {
        _pkView = [[RCLVPKView alloc] initWithHost:YES];
        _pkView.hidden = YES;
        WeakSelf(self);
        _pkView.handler = ^(BOOL isSelected) {
            StrongSelf(weakSelf);
            [strongSelf.presenter pk_mutePKUser:isSelected];
        };
    }
    return _pkView;
}

@end
