//
//  RCLVPresenter+PK.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCLVPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVPresenter (PK)
/// 同步房间状态
- (void)pk_updateRoomOnlineStatus:(NSString *)roomId;

/// 获取在线房主
- (void)pk_fetchOnlineCreatorListWithBlock:(void(^)(NSArray<RCOnlineCreatorModel *> *creatorList))completionBlock;

/// 发起pk邀请
/// @param inviteeRoomId 被邀请用户所在的房间id
/// @param inviteeUserId 被邀请人的用户id
- (void)pk_sendPKInvitation:(NSString *)inviteeRoomId invitee:(NSString *)inviteeUserId;

/// 取消pk邀请
/// @param inviteeRoomId 被邀请用户所在的房间id
/// @param inviteeUserId 被邀请人的用户id
- (void)pk_cancelPKInvitation:(NSString *)inviteeRoomId invitee:(NSString *)inviteeUserId;

/// 同意 PK 邀请
/// @param inviterRoomId 邀请人所在的房间id
/// @param inviterUserId 邀请人的用户id
- (void)pk_acceptPKInvitation:(NSString *)inviterRoomId
                      inviter:(NSString *)inviterUserId
              completionBlock:(void(^)(BOOL success))completionBlock;

/// 拒绝 PK 邀请
/// @param inviterRoomId 邀请人所在的房间id
/// @param inviterUserId 邀请人的用户id
/// @param reason 拒绝原因
- (void)pk_rejectPKInvitation:(NSString *)inviterRoomId
                      inviter:(NSString *)inviterUserId
                       reason:(NSString *)reason;

/// 同步pk状态
/// @param roomId 当前roomId
/// @param status pk状态 0:开始，2:停止
/// @param toRoomId pk对方roomId
/// @param completionBlock 回调
- (void)pk_syncPKStateFromRoomId:(NSString *)roomId
                          status:(NSInteger)status
                        toRoomId:(NSString *)toRoomId
                 completionBlock:(void(^)(BOOL success))completionBlock;

/// 退出pk连接
- (void)pk_quitPKCompletionBlock:(void(^)(BOOL success))completionBlock;

/// 获取pk的详细信息
- (void)pk_fetchPKDetailWithRoomId:(NSString *)roomId completionBlock:(void(^)(RCPKStatusModel * _Nullable statusModel))completionBlock;

/// 恢复pk
- (void)pk_resumePK:(RCLiveVideoPK *)info;

/// 静音PK对象的语音
- (void)pk_mutePKUser:(BOOL)isMute;

@end

NS_ASSUME_NONNULL_END
