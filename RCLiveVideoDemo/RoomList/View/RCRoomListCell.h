//
//  RCRoomListCell.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import <UIKit/UIKit.h>
#import "RoomListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCRoomListCell : UITableViewCell

- (void)updateCellWithName:(NSString *)roomName roomId:(NSString *)roomId;

@end

NS_ASSUME_NONNULL_END
