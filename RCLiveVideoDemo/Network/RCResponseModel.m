//
//  RCResponseModel.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "RCResponseModel.h"

@implementation RCResponseModel

- (instancetype)initWithErrorCode:(NSNumber *)errorCode
                         errorMsg:(NSString *)errorMsg {
    if (self = [super init]) {
        self.code = errorCode;
        self.msg = errorMsg;
    }
    return self;
}



@end
