//
//  UserModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject<NSCopying>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *portrait;

@end

NS_ASSUME_NONNULL_END
