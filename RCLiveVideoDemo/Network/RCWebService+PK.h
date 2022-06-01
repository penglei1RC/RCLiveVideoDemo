//
//  RCWebService+PK.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCWebService.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCWebService (PK)

/// 获取在线房主列表
/// @param responseClassm  返回对象类型
/// @param success 成功回调
/// @param failure 失败回调
+ (void)pk_roomOnlineCreatedListWithResponseClass:(nullable Class)responseClassm
                                          success:(nullable LVSSuccessCompletion)success
                                          failure:(nullable LVSFailureCompletion)failure;

/// 同步PK状态
/// @param roomId 房间Id
/// @param status 状态 0:开始，2:停止
/// @param toRoomId 对方房间Id
/// @param responseClassm  返回对象类型
/// @param success  成功回调
/// @param failure  失败回调
+ (void)pk_syncPKStateWithRoomId:(NSString *)roomId
                          status:(NSInteger)status
                        toRoomId:(NSString *)toRoomId
                   responseClass:(nullable Class)responseClassm
                         success:(nullable LVSSuccessCompletion)success
                         failure:(nullable LVSFailureCompletion)failure;


/// 判断房间是否在PK中
/// @param roomId 房间Id
/// @param responseClassm 返回对象类型
/// @param success  成功回调
/// @param failure 失败回调
+ (void)pk_checkRoomType:(NSString *)roomId
           responseClass:(nullable Class)responseClassm
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure;


/// 获取PK详细信息
/// @param roomId 房间Id
/// @param responseClassm 返回对象类型
/// @param success  成功回调
/// @param failure 失败回调
+ (void)pk_fetchPKDetail:(NSString *)roomId
           responseClass:(nullable Class)responseClassm
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
