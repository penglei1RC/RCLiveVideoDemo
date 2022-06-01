//
//  RCUserListView.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/23.
//

#import <UIKit/UIKit.h>
#import "RCUserListCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RCUserListType) {
    RCUserListTypeRequest = 1,
    RCUserListTypeRoomInvite,
    RCUserListTypeRoomUser,
    RCUserListTypeRoomCreator,
};

typedef void(^RCUserListHandler)(NSString *_Nonnull uid, NSString *_Nullable roomId, RCUserListCellActionType type);

/// 人员操作管理列表
@interface RCUserListView : UIView

@property (nonatomic, assign) RCUserListType listType;
@property (nonatomic, copy) RCUserListHandler handler;

- (instancetype)initWithCreate:(BOOL)isCreate;

- (void)show;

- (void)dismiss;

- (void)reloadData:(NSArray<UserModel *> *)users;

@end

NS_ASSUME_NONNULL_END
