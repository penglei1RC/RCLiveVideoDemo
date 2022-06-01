//
//  RCUserListCell.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RCUserListCellActionType) {
    RCUserListCellActionTypeAgree = 1,
    RCUserListCellActionTypeReject,
    RCUserListCellActionTypeInvite,
    RCUserListCellActionTypeCancelInvite,
    RCUserListCellActionTypeKick,
    RCUserListCellActionTypePKInvite,
    RCUserListCellActionTypePKCancel,
};

typedef NS_ENUM(NSUInteger, RCUserListCellStyle) {
    RCUserListCellStyleDefault = 1,
    RCUserListCellStyleKick,
    RCUserListCellStyleRequest,
    RCUserListCellStyleCancelInvite,
    RCUserListCellStylePKCreator,
};

typedef void(^RCUserListCellActionHandler) (RCUserListCellActionType type);

/// 人员操作管理列表cell
@interface RCUserListCell : UITableViewCell

@property (nonatomic, copy) RCUserListCellActionHandler handler;
@property (nonatomic, assign) RCUserListCellStyle cellStyle;

- (void)updateCellWithUser:(UserModel *)model;

@end

NS_ASSUME_NONNULL_END
