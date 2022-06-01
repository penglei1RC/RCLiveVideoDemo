//
//  RCLVPresenter.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/30.
//

#import "RCLVPresenter.h"

@implementation RCLVPresenter

- (RCRTCVideoStreamConfig *)videoStreamConfig {
    /// 根据业务需求设置视频信息：分辨率、码率和帧率等
    RCRTCVideoStreamConfig *config = [[RCRTCVideoStreamConfig alloc] init];
    config.videoSizePreset = RCRTCVideoSizePreset640x480;
    config.videoFps = RCRTCVideoFPS15;
    config.minBitrate = 350;
    config.maxBitrate = 1000;
    
    return config;
}

- (void)fetchRequestListWithBlock:(void(^)(NSArray<UserModel *> * _Nullable userList))completionBlock {
    // 先获取当前排麦的用户列表
    [[RCLiveVideoEngine shared] getRequests:^(RCLiveVideoCode code, NSArray<NSString *> * _Nonnull userIds) {
        if (code != RCLiveVideoSuccess) {
            [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_fetch_request_list_fail")];
            !completionBlock ?: completionBlock(nil);
        }
        Log(@"network fetch users info success");
        if (!userIds || userIds.count == 0) {
            !completionBlock ?: completionBlock(nil);
            [SVProgressHUD showErrorWithStatus:@"用户信息为空"];
            return ;
        }
        
        [self fetchUserInfoListWithUids:userIds completionBlock:completionBlock];
    }];
}

- (void)fetchUserInfoListWithUids:(NSArray<NSString *> *)users completionBlock:(void(^)(NSArray<UserModel *> * _Nullable userList))completionBlock {
    [RCWebService fetchUserInfoListWithUids:users responseClass:[UserModel class] success:^(id  _Nullable responseObject) {
        Log(@"获取用户信息成功");
        RCResponseModel *res = (RCResponseModel *)responseObject;
        if (res.code.integerValue == StatusCodeSuccess) {
            NSArray<UserModel *> *userInfoArr = (NSArray<UserModel *> *)res.data;
            !completionBlock ?: completionBlock(userInfoArr);
        }
    } failure:^(NSError * _Nonnull error) {
        Log(@"network fetch users info failed code: %ld",(long)error.code);
    }];
}

#pragma mark - 麦位管理
/// 闭麦
- (void)muteSeat:(RCLiveVideoSeat *)seatInfo mute:(BOOL)isMute {
    NSString *keyTips = isMute ? @"" : @"解除" ;
    [seatInfo setMute:isMute completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@闭麦成功",keyTips]];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@闭麦失败 code: %ld", keyTips,code]];
        }
    }];
}

/// 关闭音频
- (void)enableAudioSeat:(RCLiveVideoSeat *)seatInfo userEnableAudio:(BOOL)userEnableAudio {
    NSString *keyTips = userEnableAudio ? @"开启" : @"关闭";
    [seatInfo setUserEnableAudio:userEnableAudio completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@音频成功",keyTips]];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@音频失败 code: %ld", keyTips,code]];
        }
    }];
}

/// 关闭视频
- (void)enableVideoSeat:(RCLiveVideoSeat *)seatInfo userEnableVideo:(BOOL)userEnableVideo {
    NSString *keyTips = userEnableVideo ? @"开启" : @"关闭";
    [seatInfo setUserEnableVideo:userEnableVideo completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@视频成功",keyTips]];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@视频失败 code: %ld", keyTips,code]];
        }
    }];

}

@end
