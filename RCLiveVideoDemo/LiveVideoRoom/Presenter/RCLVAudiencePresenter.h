//
//  RCLVAudiencePresenter.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVAudiencePresenter : RCLVPresenter

@property (nonatomic, copy) NSString *roomId;

#pragma mark - 房间管理
/// 加入房间
- (void)joinRoom;
/// 离开房间
- (void)leaveRoomWithCompletionBlock:(void(^)(BOOL success))completionBlock;

#pragma mark - 多人连麦
/// 下麦
- (void)leaveLiveVideo;

/// 申请上麦
- (void)requestLiveVideo;
/// 取消申请上麦
- (void)cancelRequestLiveVideo;

/// 同意邀请上麦
- (void)acceptInvitation:(NSString *)uid atIndex:(NSInteger)index;
/// 拒绝邀请上麦
- (void)rejectInvitation:(NSString *)uid;
@end

NS_ASSUME_NONNULL_END
