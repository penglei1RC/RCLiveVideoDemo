//
//  RCLVAudiencePresenter.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVAudiencePresenter.h"
#import "RCLVPresenter+PK.h"

@implementation RCLVAudiencePresenter

/// 加入房间
- (void)joinRoom {
    [[RCLiveVideoEngine shared] joinRoom:self.roomId completion:^(RCLiveVideoCode code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (code == RCLiveVideoSuccess) {
                Log(@"audience join room success");
                [self pk_updateRoomOnlineStatus:self.roomId];
                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_join_success")];
            } else {
                Log(@"audience join room failed code: %ld",(long)code);
                [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"create_join_fail")];
            }
        });
    }];
}

/// 离开房间
- (void)leaveRoomWithCompletionBlock:(void(^)(BOOL success))completionBlock {
    [[RCLiveVideoEngine shared] leaveRoom:^(RCLiveVideoCode code) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (code == RCLiveVideoSuccess) {
                !completionBlock ?: completionBlock(YES);
                Log(@"live video engine leave room success");
            } else {
                !completionBlock ?: completionBlock(NO);
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Engine %@ code: %ld",LVSLocalizedString(@"live_room_delete_fail"),(long)code]];
            }
        });
    }];
}

- (void)leaveLiveVideo {
    [RCLiveVideoEngine.shared leaveLiveVideo:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"finish live success");
            [SVProgressHUD showSuccessWithStatus:@"结束连麦"];
        } else {
            Log(@"finish live failed code: %ld",code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_finish_live_fail"),code]];
        }
    }];
}

- (void)requestLiveVideo {
    [[RCLiveVideoEngine shared] requestLiveVideo:-1 completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"live request post success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_request_success")];
        } else {
            Log(@"live request post fail code: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_request_fail")];
        }
    }];
}

- (void)cancelRequestLiveVideo {
    [[RCLiveVideoEngine shared] cancelRequest:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"live request cancel success");
            [SVProgressHUD showSuccessWithStatus:LVSLocalizedString(@"live_cancel_request_success")];
        } else {
            Log(@"live request cancel fail code: %ld",(long)code);
            [SVProgressHUD showErrorWithStatus:LVSLocalizedString(@"live_cancel_request_fail")];
        }
    }];
}

/// 同意邀请上麦
- (void)acceptInvitation:(NSString *)uid atIndex:(NSInteger)index {
    [[RCLiveVideoEngine shared] acceptInvitationOfUser:uid atIndex:index completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"audience accept host invication success");
        } else {
            Log(@"audience accept host invication failed code: %ld",code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_accept_invite_fail"),code]];
        }
    }];
}

/// 拒绝邀请上麦
- (void)rejectInvitation:(NSString *)uid {
    [[RCLiveVideoEngine shared] rejectInvitationOfUser:uid completion:^(RCLiveVideoCode code) {
        if (code == RCLiveVideoSuccess) {
            Log(@"audience reject host invication success");
        } else {
            Log(@"audience reject host invication failed code: %ld",code);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:LVSLocalizedString(@"live_reject_invite_fail"),code]];
        }
    }];
}


@end
