//
//  RCLVPresenter.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/30.
//

#import <Foundation/Foundation.h>
#import <RCLiveVideoLib/RCLiveVideoLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCLVPresenter : NSObject

/// 配置视频直播参数
- (RCRTCVideoStreamConfig *)videoStreamConfig;

#pragma mark - 房间管理
- (void)fetchRequestListWithBlock:(void(^)(NSArray<UserModel *> * _Nullable userList))completionBlock;
- (void)fetchUserInfoListWithUids:(NSArray<NSString *> *)users completionBlock:(void(^)(NSArray<UserModel *> * _Nullable userList))completionBlock;

#pragma mark - 麦位管理
/// 闭麦
- (void)muteSeat:(RCLiveVideoSeat *)seatInfo mute:(BOOL)isMute;

/// 关闭音频
- (void)enableAudioSeat:(RCLiveVideoSeat *)seatInfo userEnableAudio:(BOOL)userEnableAudio;

/// 关闭视频
- (void)enableVideoSeat:(RCLiveVideoSeat *)seatInfo userEnableVideo:(BOOL)userEnableVideo;

@end

NS_ASSUME_NONNULL_END
