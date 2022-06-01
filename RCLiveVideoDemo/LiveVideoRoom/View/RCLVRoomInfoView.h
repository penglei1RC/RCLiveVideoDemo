//
//  RCLVRoomInfoView.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <UIKit/UIKit.h>
#import "CreateRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVRoomInfoView : UIView

- (void)updateUIWith:(CreateRoomModel *)model;

@end

NS_ASSUME_NONNULL_END
