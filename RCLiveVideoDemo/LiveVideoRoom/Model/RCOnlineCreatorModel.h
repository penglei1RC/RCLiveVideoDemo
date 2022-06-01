//
//  RCOnlineCreatorModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/24.
//

#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCOnlineCreatorModel : UserModel<NSCopying>

@property (nonatomic, copy) NSString *roomId;

- (instancetype)initWithRoomModel:(RoomModel *)room;
@end

NS_ASSUME_NONNULL_END
