//
//  RCLVAudienceViewController.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVAudienceViewController.h"
#import "RCLVAudiencePresenter.h"
#import "RCLVRoomInfoView.h"
#import "RCLVRoomActionView.h"
#import "RCUserListView.h"
#import <RCLiveVideoLib/RCLiveVideoLib.h>
#import "RCLVSeatItemView.h"
#import "RCLVPKView.h"

@interface RCLVAudienceViewController ()<RCLiveVideoDelegate,RCLiveVideoMixDelegate,RCLiveVideoMixDataSource,RCLiveVideoPKDelegate>

@property (nonatomic, strong, readwrite) RCLVAudiencePresenter *presenter;
@property (nonatomic, strong) RCLVRoomInfoView *infoView;
@property (nonatomic, strong) RCLVRoomActionView *actionView;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) RCUserListView *userListView;
@property (nonatomic, strong) CreateRoomModel *roomInfo;
@property (nonatomic, strong) UIAlertController *alert; // 上麦邀请弹窗
@property (nonatomic, strong) UIView *seatsView;
@property (nonatomic, strong) RCLVPKView *pkView;

@end

@implementation RCLVAudienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLiveEngine];
    [self buildLayout];
    [self.presenter joinRoom];
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
    switch (mixType) {
        case RCLiveVideoMixTypeDefault:
        case RCLiveVideoMixTypeOneToOne:
        {
            [self.previewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(self.view);
                make.width.equalTo(self.previewView.mas_height).multipliedBy(9.0 / 16);
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

- (void)updatePKStatus:(BOOL)isPK {
    self.pkView.hidden = !isPK;
}

#pragma mark - 房间管理
- (void)leaveRoom {
    [self.presenter leaveRoomWithCompletionBlock:^(BOOL success) {
        if (!success) {
            return ;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

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
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - privete method
/// 相关弹窗
- (void)showAlertWithTitle:(NSString *)title acceptBlock:(void(^)(BOOL accept))block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !block ?: block(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !block ?: block(NO);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    self.alert = alert;
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

/// 房间连麦用户更新：用户上麦、下麦等
/// @param userIds 连麦的用户
- (void)liveVideoUserDidUpdate:(NSArray<NSString *> *)userIds {
    
}

/// 直播连麦结束
- (void)liveVideoDidFinish:(RCLiveVideoFinishReason)reason {
    if (reason == RCLiveVideoFinishReasonKick) {
        [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_seate_kicked")];
    }
}

/// 申请上麦被同意：只有申请者收到回调
- (void)liveVideoRequestDidAccept {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_host_accept_request")];
}

/// 申请上麦被拒绝：只有申请者收到回调
- (void)liveVideoRequestDidReject {
    [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_host_reject_request")];
}

/// 接收到上麦邀请：只有受邀请者收到回调
- (void)liveVideoInvitationDidReceive:(NSString *)inviter atIndex:(NSInteger)index {
    [self showAlertWithTitle:@"接收到上麦邀请" acceptBlock:^(BOOL accept) {
        if (accept) {
            [self.presenter acceptInvitation:inviter atIndex:index];
        } else {
            [self.presenter rejectInvitation:inviter];
        }
    }];
}

/// 邀请上麦已被取消：只有受邀请者收到回调
- (void)liveVideoInvitationDidCancel {
    [self.alert dismissViewControllerAnimated:YES completion:nil];
}

/// 被踢出房间的用户接收到回调，离开房间
- (void)userDidKickOut:(NSString *)userId byOperator:(NSString *)operatorId {
    [self.presenter leaveRoomWithCompletionBlock:^(BOOL success) {
        if (!success) {
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kicked_by_user"), operatorId]];
    }];
}

/// 房间信息更新
/// @param key 房间信息属性
/// @param value 房间信息内容
- (void)roomInfoDidUpdate:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:@"roomNotice"]) {
        [SVProgressHUD showInfoWithStatus:value];
    }
}

/// 房间已关闭
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
- (RCLVAudiencePresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCLVAudiencePresenter new];
        _presenter.roomId = self.roomId;
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
                       @[@(RCLVRoomActionTypeAudienceRequest),
                         @(RCLVRoomActionTypeAudienceCancelRequest),
                         @(RCLVRoomActionTypeGetRequestList),
                         @(RCLVRoomActionTypeLeaveRoom),
                         @(RCLVRoomActionTypeLeaveFinishLive)]];
        WeakSelf(self);
        _actionView.hander = ^(RCLVRoomActionType type, BOOL isSelected) {
            StrongSelf(weakSelf);
            switch (type) {
                case RCLVRoomActionTypeAudienceRequest:
                    [strongSelf.presenter requestLiveVideo];
                    break;
                case RCLVRoomActionTypeAudienceCancelRequest:
                    [strongSelf.presenter cancelRequestLiveVideo];
                    break;
                case RCLVRoomActionTypeGetRequestList:
                    [strongSelf fetchRequestList];
                    break;
                case RCLVRoomActionTypeLeaveRoom:
                    [strongSelf leaveRoom];
                    break;
                case RCLVRoomActionTypeLeaveFinishLive:
                    [strongSelf.presenter leaveLiveVideo];

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
    }
    return _userListView;
}

- (RCLVPKView *)pkView {
    if (!_pkView) {
        _pkView = [[RCLVPKView alloc] initWithHost:NO];
        _pkView.hidden = YES;
    }
    return _pkView;
}

@end
