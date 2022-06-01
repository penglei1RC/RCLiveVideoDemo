//
//  RCLVRoomActionView.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RCLVRoomActionType) {
    RCLVRoomActionTypeAudienceRequest = 1,
    RCLVRoomActionTypeAudienceCancelRequest,
    RCLVRoomActionTypeHostInvite,
    RCLVRoomActionTypeHostCancelInvite,
    RCLVRoomActionTypeGetRoomUsers,
    RCLVRoomActionTypeGetRequestList,
    RCLVRoomActionTypePK,
    RCLVRoomActionTypeLeaveRoom,
    RCLVRoomActionTypeLeaveFinishLive,
    RCLVRoomActionTypeSetMixType,
    RCLVRoomActionTypeSetNotice,
};

typedef void(^RCLVRoomActionHandler)(RCLVRoomActionType type, BOOL isSelected);
@interface RCLVRoomActionView : UIView

@property (nonatomic, copy) RCLVRoomActionHandler hander;
@property (nonatomic, assign) BOOL isPK;

- (instancetype)initWithTypes:(NSArray *)types;

@end

NS_ASSUME_NONNULL_END
