//
//  RCLVPresenter+PK.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCLVPresenter+PK.h"

@implementation RCLVPresenter (PK)
- (void)pk_updateRoomOnlineStatus:(NSString *)roomId {
    [RCWebService updateCurrentRoom:roomId responseClass:nil success:^(id  _Nullable responseObject) {
        Log(@"同步房间在线状态成功");
    } failure:^(NSError * _Nonnull error) {
        Log(@"同步房间在线状态失败");
    }];
}

- (void)pk_fetchOnlineCreatorListWithBlock:(void(^)(NSArray<RCOnlineCreatorModel *> *creatorList))completionBlock {
    [RCWebService pk_roomOnlineCreatedListWithResponseClass:[RoomModel class] success:^(id  _Nullable responseObject) {
        Log(@"获取在线房主成功");
        RCResponseModel *res = (RCResponseModel *)responseObject;
        NSArray<RoomModel *> *roomList = (NSArray<RoomModel *> *)res.data;
        NSMutableArray<RCOnlineCreatorModel *> *creatorList = [NSMutableArray array];
        for (RoomModel *room in roomList) {
            RCOnlineCreatorModel *creator = [[RCOnlineCreatorModel alloc] initWithRoomModel:room];
            [creatorList addObject:creator];
        }
        !completionBlock ?: completionBlock(creatorList.copy);
    } failure:^(NSError * _Nonnull error) {
        !completionBlock ?: completionBlock(nil);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"获取在线房失败 code: %ld",error.code]];
    }];
}

/// 发起pk邀请
- (void)pk_sendPKInvitation:(NSString *)inviteeRoomId invitee:(NSString *)inviteeUserId {
    [RCWebService pk_checkRoomType:inviteeRoomId responseClass:nil success:^(id  _Nullable responseObject) {
        RCResponseModel *model = (RCResponseModel *)responseObject;
        if (!model.data) {
            [SVProgressHUD showErrorWithStatus:@"对方房间正在PK中"];
            return ;
        }
        [[RCLiveVideoEngine shared] sendPKInvitation:inviteeRoomId invitee:inviteeUserId completion:^(RCLiveVideoCode code) {
            if (code == RCLiveVideoSuccess) {
                [SVProgressHUD showSuccessWithStatus:@"发送PK邀请成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"发送PK邀请失败 code: %ld",(long)code]];
            }
        }];
    } failure:^(NSError * _Nonnull error) {
        Log(@"查询房间是否在PK中失败");
    }];
}

/// 取消pk邀请
- (void)pk_cancelPKInvitation:(NSString *)inviteeRoomId invitee:(NSString *)inviteeUserId {
    [[RCLiveVideoEngine shared] cancelPKInvitation:inviteeRoomId invitee:inviteeUserId completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"取消PK邀请成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"取消PK邀请失败 code: %ld",(long)code]];
        }
    }];
}

/// 同意 PK 邀请
- (void)pk_acceptPKInvitation:(NSString *)inviterRoomId
                      inviter:(NSString *)inviterUserId
              completionBlock:(void(^)(BOOL success))completionBlock {
    [[RCLiveVideoEngine shared] acceptPKInvitation:inviterRoomId inviter:inviterUserId completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"同意PK邀请成功"];
            !completionBlock ?: completionBlock(YES);
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"同意PK邀请失败code: %ld", (long)code]];
            !completionBlock ?: completionBlock(NO);
        }
    }];
}

/// 拒绝 PK 邀请
/// @param inviterRoomId 邀请人所在的房间id
/// @param inviterUserId 邀请人的用户id
/// @param reason 拒绝原因
- (void)pk_rejectPKInvitation:(NSString *)inviterRoomId
                   inviter:(NSString *)inviterUserId
                    reason:(NSString *)reason {
    [[RCLiveVideoEngine shared] rejectPKInvitation:inviterRoomId inviter:inviterUserId reason:reason completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"拒绝PK邀请成功：%@", reason]];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"拒绝PK邀请失败：%@ code: %ld", reason, (long)code]];
        }
    }];
}

- (void)pk_syncPKStateFromRoomId:(NSString *)roomId
                          status:(NSInteger)status
                        toRoomId:(NSString *)toRoomId
                 completionBlock:(void(^)(BOOL success))completionBlock {
    [RCWebService pk_syncPKStateWithRoomId:roomId status:status toRoomId:toRoomId responseClass:nil success:^(id  _Nullable responseObject) {
        Log(@"pk同步成功");
        !completionBlock ?: completionBlock(YES);
    } failure:^(NSError * _Nonnull error) {
        Log(@"pk同步失败");
        !completionBlock ?: completionBlock(NO);
    }];
}

- (void)pk_quitPKCompletionBlock:(void(^)(BOOL success))completionBlock {
    [[RCLiveVideoEngine shared] quitPK:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"退出PK成功"];
            !completionBlock ?: completionBlock(YES);
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"退出PK失败 code: %ld",(long)code]];
            !completionBlock ?: completionBlock(YES);
        }
    }];
}

- (void)pk_fetchPKDetailWithRoomId:(NSString *)roomId completionBlock:(void(^)(RCPKStatusModel * _Nullable statusModel))completionBlock {
    [RCWebService pk_fetchPKDetail:roomId responseClass:[RCPKStatusModel class] success:^(id  _Nullable responseObject) {
        Log(@"获取PK详情成功");
        RCPKStatusModel *model = (RCPKStatusModel *)((RCResponseModel *)responseObject).data;
        !completionBlock ?: completionBlock(model);
    } failure:^(NSError * _Nonnull error) {
        Log(@"获取PK详情失败");
        !completionBlock ?: completionBlock(nil);
    }];
}

- (void)pk_resumePK:(RCLiveVideoPK *)info {
    [RCLiveVideoEngine.shared resumePK:info completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"恢复PK成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"恢复PK失败 code: %ld",(long)code]];
        }
    }];
}

- (void)pk_mutePKUser:(BOOL)isMute {
    NSString *keyTips = isMute ? @"" : @"解除" ;
    [[RCLiveVideoEngine shared] mutePKUser:isMute completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@静音 PK 对象成功",keyTips]];
        } else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@静音 PK 对象失败 code: %ld",keyTips,(long)code]];
        }
    }];
}

@end
