//
//  RCUserManager.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCUserManager.h"

static NSString *const kUserAuthKey = @"lvs.user.auth";
static NSString *const kUserImTokenKey = @"lvs.user.imtoken";
static NSString *const kUserUidKey = @"lvs.user.uid";
static NSString *const kUserUserNameKey = @"lvs.user.username";
static NSString *const kUserPhoneKey = @"lvs.user.phone";

@implementation RCUserManager

+ (BOOL)isLogin {
    return [self imToken].length != 0;
}

+ (void)clearLoginStatus {
    [self _removeValueForKey:kUserAuthKey];
    [self _removeValueForKey:kUserImTokenKey];
    [self _removeValueForKey:kUserUidKey];
    [self _removeValueForKey:kUserUserNameKey];
    [self _removeValueForKey:kUserPhoneKey];
}

+ (NSString *)saveAuth:(NSString *)auth {
    return [self _saveValue:auth forKey:kUserAuthKey];;
}

+ (NSString *)saveImToken:(NSString *)imToken {
    return [self _saveValue:imToken forKey:kUserImTokenKey];
}

+ (NSString *)saveUid:(NSString *)uid {
    return [self _saveValue:uid forKey:kUserUidKey];
}

+ (NSString *)saveUserName:(NSString *)userName {
    return (NSString *)[self _saveValue:userName forKey:kUserUserNameKey];
}

+ (NSString *)savePhone:(NSString * _Nonnull)phone {
    return [self _saveValue:phone forKey:kUserPhoneKey];
}

+ (NSString *)auth {
    return [self _valueForKey:kUserAuthKey];
}

+ (NSString *)imToken {
    return [self _valueForKey:kUserImTokenKey];
}

+ (NSString *)uid {
    return [self _valueForKey:kUserUidKey];
}

+ (NSString *)userName {
    return [self _valueForKey:kUserUserNameKey];
}

+ (NSString *)phone {
    return [self _valueForKey:kUserPhoneKey];
}

+ (id)_saveValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil || key == nil || value.length == 0 || key.length == 0) {
        NSAssert(NO, @"LVSUser: value and key must be nonnull");
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
    return  value;
}

+ (void)_removeValueForKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        NSAssert(NO, @"LVSUser: key must be nonnull");
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
}

+ (id)_valueForKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        NSAssert(NO, @"LVSUser: key must be nonnull");
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id value = [userDefault valueForKey:key];
    return value;
}

@end
