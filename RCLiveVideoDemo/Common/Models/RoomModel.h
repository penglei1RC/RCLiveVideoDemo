//
//  RoomModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomModel : NSObject

@property (nonatomic, copy)   NSString *roomId;
@property (nonatomic, copy)   NSString *roomName;
@property (nonatomic, copy)   NSString *themePictureUrl;
@property (nonatomic, copy)   NSString *backgroundUrl;
@property (nonatomic, assign) NSInteger isPrivate;
@property (nonatomic, copy)   NSString *password;
@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, assign) NSInteger updateDt;
@property (nonatomic, strong) UserModel *createUser;

@end

NS_ASSUME_NONNULL_END
