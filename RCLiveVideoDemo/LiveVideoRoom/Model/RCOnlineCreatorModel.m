//
//  RCOnlineCreatorModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/24.
//

#import "RCOnlineCreatorModel.h"

@implementation RCOnlineCreatorModel

- (instancetype)initWithRoomModel:(RoomModel *)room {
    if (self = [super init]) {
        self.userId = room.createUser.userId;
        self.userName = room.createUser.userName;
        self.portrait = room.createUser.portrait;
        self.roomId = room.roomId;
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSString *)description {
    return [self yy_modelDescription];
}

@end
