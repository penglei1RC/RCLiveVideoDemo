//
//  UserModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "UserModel.h"

@implementation UserModel

- (id)copyWithZone:(nullable NSZone *)zone {
    UserModel *instance = [[[self class] allocWithZone:zone] init];
    instance.userId = self.userId;
    instance.userName = self.userName;
    instance.portrait = self.portrait;
    return instance;
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
