//
//  RCWebService.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LVSNetworkConst.h"

typedef NS_ENUM(NSUInteger, LVSRoomType) {
    LVSRoomTypeVoice = 1,
    LVSRoomTypeRadio,
    LVSRoomTypeVideo,
};

typedef void(^LVSSuccessCompletion)(id _Nullable responseObject);

typedef void(^LVSFailureCompletion)(NSError * _Nonnull error);

typedef NS_ENUM(NSUInteger, StatusCode) {
    StatusCodeSuccess = 10000,
};

NS_ASSUME_NONNULL_BEGIN

@interface RCWebService : AFHTTPSessionManager

/// 获取实例
+ (instancetype)shareInstance;


/// GET 请求
/// @param URLString  path url
/// @param parameters 入参
/// @param auth  接口是否需要签名
/// @param responseClass  返回对象类型 缺省值为字典
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable id)parameters
                         auth:(BOOL)auth
                responseClass:(nullable Class)responseClass
                      success:(nullable LVSSuccessCompletion)success
                      failure:(nullable LVSFailureCompletion)failure;

/// POST 请求
/// @param URLString path url
/// @param parameters 入参
/// @param auth 接口是否需要签名
/// @param responseClass 返回对象类型 缺省值为字典
/// @param success 成功回调
/// @param failure 失败回调
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable id)parameters
                          auth:(BOOL)auth
                 responseClass:(nullable Class)responseClass
                       success:(nullable LVSSuccessCompletion)success
                       failure:(nullable LVSFailureCompletion)failure;

/// 登录
/// @param number 电话号码
/// @param verifyCode 验证码   //测试环境验证码可以输入任意值
/// @param deviceId  设备ID UUIDString
/// @param userName 昵称
/// @param portrait 头像
/// @param success 成功回调
/// @param failure 失败回调
+ (void)loginWithPhoneNumber:(NSString *)number
                  verifyCode:(NSString *)verifyCode
                    deviceId:(NSString *)deviceId
                    userName:(nullable NSString *)userName
                    portrait:(nullable NSString *)portrait
               responseClass:(nullable Class)responseClass
                     success:(nullable LVSSuccessCompletion)success
                     failure:(nullable LVSFailureCompletion)failure;

/// 创建房间
/// @param name 房间名
/// @param isPrivate  是否是私密房间  0 否  1 是
/// @param backgroundUrl 背景图片
/// @param themePictureUrl 主题照片
/// @param password  私密房间密码MD5
/// @param kv  保留值，可缺省传空
/// @param success 成功回调
/// @param failure 失败回调
+ (void)createRoomWithName:(NSString *)name
                 isPrivate:(NSInteger)isPrivate
             backgroundUrl:(NSString *)backgroundUrl
           themePictureUrl:(NSString *)themePictureUrl
                  password:(NSString *)password
                        kv:(NSArray <NSDictionary *>*)kv
             responseClass:(nullable Class)responseClass
                   success:(nullable LVSSuccessCompletion)success
                   failure:(nullable LVSFailureCompletion)failure;

/// 删除房间
/// @param roomId 房间ID
/// @param success 成功回调
/// @param failure 失败回调
+ (void)deleteRoomWithRoomId:(NSString *)roomId
                     success:(nullable LVSSuccessCompletion)success
                     failure:(nullable LVSFailureCompletion)failure;


/// 房间列表
/// @param size 返回数据量
/// @param page 分页
/// @param type 房间类型 1.语聊 2.电台  3.直播
/// @param success 成功回调
/// @param failure 失败回调
+ (void)roomListWithSize:(NSInteger)size
                    page:(NSInteger)page
                    type:(LVSRoomType)type
           responseClass:(nullable Class)responseClass
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure;


/// 获取直播间内的用户
/// @param roomId  房间id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)roomUserListWithRoomId:(NSString *)roomId
                 responseClass:(nullable Class)responseClass
                       success:(nullable LVSSuccessCompletion)success
                       failure:(nullable LVSFailureCompletion)failure;

/// 批量获取用户信息
/// @param uids  用户uid列表
/// @param success 成功回调
/// @param failure 失败回调
+ (void)fetchUserInfoListWithUids:(NSArray<NSString *>*)uids
                    responseClass:(nullable Class)responseClass
                          success:(nullable LVSSuccessCompletion)success
                          failure:(nullable LVSFailureCompletion)failure;

/// 更新当前房间
/// @param roomId 房间id
/// @param success 成功回调
/// @param failure 失败回调
+ (void)updateCurrentRoom:(NSString *)roomId
            responseClass:(nullable Class)responseClass
                  success:(nullable LVSSuccessCompletion)success
                  failure:(nullable LVSFailureCompletion)failure;

@end

NS_ASSUME_NONNULL_END
