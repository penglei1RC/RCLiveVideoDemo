//
//  RoomListModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "RoomListModel.h"

@implementation RoomListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rooms" : [RoomListRoomModel class]};
}

@end

@implementation RoomListRoomModel

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
