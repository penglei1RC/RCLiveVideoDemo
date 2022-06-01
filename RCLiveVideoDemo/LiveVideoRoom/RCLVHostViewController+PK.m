//
//  RCLVHostViewController+PK.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCLVHostViewController+PK.h"
#import "RCLVPresenter+PK.h"

@implementation RCLVHostViewController (PK)

- (void)pk_loadPKModule {
    WeakSelf(self);
    [self.presenter pk_fetchPKDetailWithRoomId:self.roomInfo.roomId completionBlock:^(RCPKStatusModel * _Nullable statusModel) {
        StrongSelf(weakSelf);
        if (statusModel.roomScores.count != 2) {
            [strongSelf updatePKStatus:NO];
            return ;
        }
        // 如果是pk房间，则需要恢复pk
        [strongSelf updatePKStatus:YES];
        RCPKStatusRoomScore *roomscore0 = statusModel.roomScores[0];
        RCPKStatusRoomScore *roomscore1 = statusModel.roomScores[1];
        RCLiveVideoPK *pkInfo;
        if (roomscore0.leader) {
            pkInfo = [[RCLiveVideoPK alloc] initWithInviterId:roomscore0.userId
                                                inviterRoomId:roomscore0.roomId
                                                    inviteeId:roomscore1.userId
                                                inviteeRoomId:roomscore1.roomId];
            
        } else {
            pkInfo = [[RCLiveVideoPK alloc] initWithInviterId:roomscore1.userId
                                                inviterRoomId:roomscore1.roomId
                                                    inviteeId:roomscore0.userId
                                                inviteeRoomId:roomscore0.roomId];
        }
        switch (statusModel.statusMsg) {
            case 0:
            case 1:
            {
                [strongSelf.presenter pk_resumePK:pkInfo];
            }
                break;
            default:
                break;
        }
        
    }];
}

- (void)pk_invite:(BOOL)isInvite {
    if (!isInvite) {
        [self pk_quick];
        return ;
    }
    WeakSelf(self);
    [self.presenter pk_fetchOnlineCreatorListWithBlock:^(NSArray<RCOnlineCreatorModel *> * _Nonnull creatorList) {
        StrongSelf(weakSelf);
        strongSelf.userListView.listType = RCUserListTypeRoomCreator;
        [strongSelf.userListView reloadData:creatorList];
        [strongSelf.userListView show];
    }];
}

- (void)pk_quick {
    WeakSelf(self);
    [self.presenter pk_quitPKCompletionBlock:^(BOOL success) {
        StrongSelf(weakSelf);
        [strongSelf updatePKStatus:!success];
        if (success) {
            return ;
        }
        RCLiveVideoPK *pkInfo = RCLiveVideoEngine.shared.pkInfo;
        /// 当前主播是否为邀请者
        BOOL isMeInvite = [self.roomInfo.roomId isEqualToString:pkInfo.inviterRoomId];
        NSString *roomId = (isMeInvite) ? pkInfo.inviterRoomId : pkInfo.inviteeRoomId;
        NSString *toRoomId = (isMeInvite) ? pkInfo.inviteeRoomId : pkInfo.inviterRoomId;
        [strongSelf.presenter pk_syncPKStateFromRoomId:roomId status:2 toRoomId:toRoomId completionBlock:^(BOOL success) {
        }];
    }];
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

#pragma mark - RCLiveVideoPKDelegate
/// 收到邀请 PK 的回调
/// @param inviterRoomId 邀请者的房间id
/// @param inviterUserId 邀请者的用户id
- (void)didReceivePKInvitationFromRoom:(NSString *)inviterRoomId byUser:(NSString *)inviterUserId {
    [self showAlertWithTitle:@"来啊，PK啊" acceptBlock:^(BOOL accept) {
        if (accept) {
            WeakSelf(self);
            [self.presenter pk_acceptPKInvitation:inviterRoomId inviter:inviterUserId completionBlock:^(BOOL success) {
                StrongSelf(weakSelf);
                if (!success) {
                    return;
                }
                [strongSelf updatePKStatus:YES];
            }];
            
        } else {
            [self.presenter pk_rejectPKInvitation:inviterRoomId inviter:inviterUserId reason:@"不PK了，🙏"];
        }
    }];
}

/// 邀请者取消 PK 邀请回调
/// @param inviterRoomId 邀请者的房间id
/// @param inviterUserId 邀请者的用户id
- (void)didCancelPKInvitationFromRoom:(NSString *)inviterRoomId byUser:(NSString *)inviterUserId {
    [self.alert dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"用户%@取消了%@房间的PK邀请",inviterUserId, inviterRoomId]];
}

/// PK 邀请被同意回调
/// @param inviteeRoomId 被邀请者的房间id
/// @param inviteeUserId 被邀请者的用户id
- (void)didAcceptPKInvitationFromRoom:(NSString *)inviteeRoomId
                               byUser:(NSString *)inviteeUserId {
}

/// PK 邀请被拒绝回调
/// @param inviteeRoomId 被邀请者的房间id
/// @param inviteeUserId 被邀请者的用户id
/// @param reason 原因
- (void)didRejectPKInvitationFromRoom:(NSString *)inviteeRoomId
                               byUser:(NSString *)inviteeUserId
                               reason:(NSString *)reason {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"用户%@拒绝了您的PK邀请",inviteeUserId]];
}

/// PK 连接成功时触发此回调
- (void)didBeginPK:(RCLiveVideoCode)code {
    RCLiveVideoPK *pkInfo = RCLiveVideoEngine.shared.pkInfo;
    /// 更新PK状态
    [self updatePKStatus:YES];
    /// 同步服务器信息
    if ([pkInfo.inviterUserId isEqualToString: self.roomInfo.createUser.userId]) {
        return ;
    }
    WeakSelf(self);
    [self.presenter pk_syncPKStateFromRoomId:pkInfo.inviterRoomId status:0 toRoomId:pkInfo.inviteeRoomId completionBlock:^(BOOL success) {
        StrongSelf(weakSelf);
        if (success) {
            return ;
        }
        [strongSelf pk_quick];
    }];
}

/// 对方结束 PK 时触发此回调
/// 注意：收到该回调后会自动退出 PK 连接
- (void)didFinishPK:(RCLiveVideoCode)code {
    /// 更新PK状态
    [self updatePKStatus:NO];
}

@end
