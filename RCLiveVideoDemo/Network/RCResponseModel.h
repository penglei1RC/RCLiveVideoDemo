//
//  RCResponseModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, RCResponseType) {
    RCResponseTypeNormal = 0,
    RCResponseTypeLoading,
    RCResponseTypeNoData,
    RCResponseTypeOffline,
    RCResponseTypeSeverError,
};

@interface RCResponseModel : NSObject

@property (nonatomic, nullable, strong) NSNumber *code;
@property (nonatomic, nullable, strong) NSString *msg;
/// 传入的rspClass具体模型，或者都为rspClass模型的数组
@property (nonatomic, nullable, strong) id data;

- (instancetype)initWithErrorCode:(NSNumber *)errorCode
                         errorMsg:(NSString *)errorMsg;

@end

NS_ASSUME_NONNULL_END
