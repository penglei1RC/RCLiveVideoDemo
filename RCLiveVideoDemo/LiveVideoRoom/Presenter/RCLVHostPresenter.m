//
//  RCLVHostPresenter.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVHostPresenter.h"
#import <CommonCrypto/CommonDigest.h>
#import <RCLiveVideoLib/RCLiveVideoLib.h>
#import "RCLVPresenter+PK.h"

@interface RCLVHostPresenter ()

@property (nonatomic, strong) CreateRoomModel *roomInfo;

@end

@implementation RCLVHostPresenter

- (void)createRoomWithCompletionBlock:(void(^)(CreateRoomModel * _Nullable roomInfo))completionBlock {
    NSString *roomName = [self generateRoomName];
    NSString *password = [self md5:@"1234"];
    NSString *imageUrl = @"https://img2.baidu.com/it/u=2842763149,821152972&fm=26&fmt=auto";
    
    [RCWebService createRoomWithName:roomName
                           isPrivate:0
                       backgroundUrl:imageUrl
                     themePictureUrl:imageUrl
                            password:password
                                  kv:@[]
                       responseClass:[CreateRoomModel class]
                             success:^(id  _Nullable responseObject) {
        if (!responseObject) {
            return ;
        }
        RCResponseModel *res = (RCResponseModel *)responseObject;
        if (res.data != nil) {
            [SVProgressHUD showSuccessWithStatus:(@"新建房间成功")];
            CreateRoomModel *model = (CreateRoomModel *)res.data;
            self.roomInfo = model;
            !completionBlock ?: completionBlock(model);
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",@"新建房间失败",(long)res.code]];
            !completionBlock ?: completionBlock(nil);
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",@"新建房间失败",(long)error.code]];
        !completionBlock ?: completionBlock(nil);
    }];
}

/// 开始直播
- (void)beginWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    [[RCLiveVideoEngine shared] begin:self.roomInfo.roomId
                           completion:^(RCLiveVideoCode code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (code == RCLiveVideoSuccess) {
                Log(@"live video engine push stream success");
                [self pk_updateRoomOnlineStatus:self.roomInfo.roomId];
                !completionBlock ?: completionBlock(YES);
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ code: %ld",LVSLocalizedString(@"host_push_stream"),(long)code]];
                !completionBlock ?: completionBlock(NO);
            }
        });
    }];
}

- (void)fetchInvitationsWithBlock:(void (^)(NSArray<UserModel *> * _Nullable))completionBlock {
    [[RCLiveVideoEngine shared] getInvitations:^(RCLiveVideoCode code, NSArray<NSString *> * _Nonnull userIds) {
        if (code != RCLiveVideoSuccess) {
            [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_fetch_invite_list_fail")];
            !completionBlock ?: completionBlock(nil);
        }
        Log(@"host engine fetch invite users success");
        if (!userIds || userIds.count == 0) {
            !completionBlock ?: completionBlock(nil);
            [SVProgressHUD showErrorWithStatus:@"用户信息为空"];
            return ;
        }
        
        [self fetchUserInfoListWithUids:userIds completionBlock:completionBlock];
    }];
}

- (void)fetchRoomUserListWithBlock:(void(^)(NSArray<UserModel *> *userList))completionBlock {
    [RCWebService roomUserListWithRoomId:self.roomInfo.roomId responseClass:[UserModel class]
                               success:^(id  _Nullable responseObject) {
        Log(@"获取用户信息成功");
        RCResponseModel *res = (RCResponseModel *)responseObject;
        if (res.code.integerValue == StatusCodeSuccess) {
            NSArray<UserModel *> *userInfoArr = (NSArray<UserModel *> *)res.data;
            !completionBlock ?: completionBlock(userInfoArr);
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取用户列表失败 code: %@",res.code]];
        }
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取用户列表失败 code: %ld",error.code]];
    }];
}

/// 结束直播
- (void)finish {
    // 1. 销毁房间，服务器会默认结束直播
    [RCWebService deleteRoomWithRoomId:self.roomInfo.roomId success:^(id  _Nullable responseObject) {
        Log(@"network live room close success");
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"NetWork %@ code: %ld",LVSLocalizedString(@"live_room_delete_fail"),(long)error.code]];
    }];
}

/// 踢用户出直播间
- (void)kickOutRoom:(NSString *)uid {
    [[RCLiveVideoEngine shared] kickOutRoom:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host kick audience success");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_success"),uid]];
        } else {
            Log(@"host kick audience failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_fail"),(long)code]];
        }
    }];
}

- (void)acceptRequest:(NSString *)uid {
    [[RCLiveVideoEngine shared] acceptRequest:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host agree audience live request success");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_accept_success"),uid]];
        } else {
            Log(@"host agree audience live request failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_accept_fail"),(long)code]];
        }
    }];
}

- (void)rejectRequest:(NSString *)uid {
    [[RCLiveVideoEngine shared] rejectRequest:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host reject audience live request success");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_reject_success"),uid]];
        } else {
            Log(@"host reject audience live request failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_audience_request_reject_fail"),(long)code]];
        }
    }];
}

/// 邀请用户上麦
- (void)inviteLiveVideo:(NSString *)uid {
    [[RCLiveVideoEngine shared] inviteLiveVideo:uid atIndex:-1 completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host invite audience success");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_audience_success"),uid]];
        } else {
            Log(@"host invite audience failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_audience_fail"),(long)code]];
        }
    }];
}

/// 取消邀请用户上麦
- (void)cancelInviteLiveVideo:(NSString *)uid {
    [[RCLiveVideoEngine shared] cancelInvitation:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host cancel invite success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_invite_cancel_success")];
        } else {
            Log(@"hhost cancel invite failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_invite_cancel_fail"),(long)code]];
        }
    }];
}

- (void)kickLiveVideoFromSeat:(NSString *)uid {
    [[RCLiveVideoEngine shared] kickUserFromSeat:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"host kick live audience success");
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_success"),uid]];
        } else {
            Log(@"host kick live audience failed ocde: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_kick_audience_fail"),(long)code]];
        }
    }];
}

- (void)setMixType:(RCLiveVideoMixType)type {
    if (type == [RCLiveVideoEngine shared].currentMixType) {
        return ;
    }
    
    [[RCLiveVideoEngine shared] setMixType:type completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"设置视频合流布局类型成功");
        } else {
            Log(@"设置视频合流布局类型失败");
        }
    }];
}

#pragma mark - 麦位管理
/// 锁麦
- (void)lockSeat:(RCLiveVideoSeat *)seatInfo lock:(BOOL)isLocking {
    NSString *keyTips = isLocking ? @"锁定" : @"解锁";
    [seatInfo setLock:isLocking completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@成功",keyTips]];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"座位%@失败 code: %ld", keyTips,code]];
        }
    }];
}

#pragma mark - 房间属性
/// 更新房间自定义属性，建议属性数量<50
/// @param roomInfo 房间信息属性<key, value>
- (void)updateRoomInfo:(NSDictionary<NSString *, NSString *> *)roomInfo {
    [[RCLiveVideoEngine shared] setRoomInfo:roomInfo completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"设置房间信息成功");
        } else {
            Log(@"设置房间信息失败");
        }
    }];
}

#pragma mark - private method
- (NSString *)generateRoomName {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    NSString *suffixString = [[RCUserManager phone] substringFromIndex:7];
    NSString *roomName = [NSString stringWithFormat:@"%@ %@", suffixString, dateString];
    return roomName;
}


- (NSString *)md5:(NSString *)pwd {
    const char *cStr = [pwd UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", digest[i]];
    }
    
    return result;
}

@end
