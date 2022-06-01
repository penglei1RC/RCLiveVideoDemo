//
//  RCLVHostPresenter.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVHostPresenter : RCLVPresenter

#pragma mark - 房间管理
/// 新建房间
/// @param completionBlock 回调，roomInfo == nil 即失败
- (void)createRoomWithCompletionBlock:(void(^)(CreateRoomModel * _Nullable roomInfo))completionBlock;

/// 开始直播
- (void)beginWithCompletionBlock:(void(^)(BOOL success))completionBlock;

/// 结束直播
- (void)finish;

/// 邀请列表
- (void)fetchInvitationsWithBlock:(void (^)(NSArray<UserModel *> * _Nullable))completionBlock;

/// 房间用户
- (void)fetchRoomUserListWithBlock:(void(^)(NSArray<UserModel *> *userList))completionBlock;

/// 踢用户出房间
- (void)kickOutRoom:(NSString *)uid;

#pragma mark - 多人连麦
/// 同意用户上麦
- (void)acceptRequest:(NSString *)uid;
/// 拒绝用户上麦
- (void)rejectRequest:(NSString *)uid;
/// 邀请用户上麦
- (void)inviteLiveVideo:(NSString *)uid;
/// 取消邀请用户上麦
- (void)cancelInviteLiveVideo:(NSString *)uid;
/// 设置连麦布局类型
- (void)setMixType:(RCLiveVideoMixType)type;

#pragma mark - 麦位管理
/// 锁麦
- (void)lockSeat:(RCLiveVideoSeat *)seatInfo lock:(BOOL)isLocking;

#pragma mark - 房间属性
/// 更新房间自定义属性，建议属性数量<50
/// @param roomInfo 房间信息属性<key, value>
- (void)updateRoomInfo:(NSDictionary<NSString *, NSString *> *)roomInfo;

#pragma mark - 用户管理
/// 抱下麦
- (void)kickLiveVideoFromSeat:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
