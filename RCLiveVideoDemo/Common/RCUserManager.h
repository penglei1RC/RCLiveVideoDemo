//
//  RCUserManager.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCUserManager : NSObject

+ (BOOL)isLogin;
+ (void)clearLoginStatus;

+ (NSString *)saveAuth:(NSString * _Nonnull)auth;
+ (NSString *)saveImToken:(NSString * _Nonnull)imToken;
+ (NSString *)saveUid:(NSString * _Nonnull)uid;
+ (NSString *)saveUserName:(NSString * _Nonnull)userName;
+ (NSString *)savePhone:(NSString * _Nonnull)phone;

+ (NSString * _Nullable)auth;
+ (NSString * _Nullable)imToken;
+ (NSString * _Nullable)uid;
+ (NSString * _Nullable)userName;
+ (NSString * _Nullable)phone;

@end

NS_ASSUME_NONNULL_END
