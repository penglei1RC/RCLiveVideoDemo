//
//  RCPKStatusModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/25.
//

#import "RCPKStatusModel.h"

@implementation RCPKStatusModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"roomScores" : [RCPKStatusRoomScore class]};
}

@end

@implementation RCPKStatusRoomScore
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userInfoList" : [UserModel class]};
}

@end
