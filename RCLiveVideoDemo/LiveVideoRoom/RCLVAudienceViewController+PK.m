//
//  RCLVAudienceViewController+PK.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCLVAudienceViewController+PK.h"
#import "RCLVPresenter+PK.h"

@implementation RCLVAudienceViewController (PK)
- (void)pk_loadPKModule {
    WeakSelf(self);
    [self.presenter pk_fetchPKDetailWithRoomId:self.presenter.roomId completionBlock:^(RCPKStatusModel * _Nullable statusModel) {
        StrongSelf(weakSelf);
        if (statusModel.roomScores.count != 2) {
            [strongSelf updatePKStatus:NO];
            return ;
        }
        // 如果是pk房间，则需要恢复pk
        [strongSelf updatePKStatus:YES];
    }];
}

#pragma mark - RCLiveVideoPKDelegate
/// PK 连接成功时触发此回调
- (void)didBeginPK:(RCLiveVideoCode)code {
    /// 更新PK状态
    [self updatePKStatus:YES];
}

/// 对方结束 PK 时触发此回调
/// 注意：收到该回调后会自动退出 PK 连接
- (void)didFinishPK:(RCLiveVideoCode)code {
    /// 更新PK状态
    [self updatePKStatus:NO];
}

@end
