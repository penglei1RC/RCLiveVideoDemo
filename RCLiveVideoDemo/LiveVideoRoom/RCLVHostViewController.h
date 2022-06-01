//
//  RCLVHostViewController.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <UIKit/UIKit.h>
#import "RCLVHostPresenter.h"
#import "RCUserListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVHostViewController : UIViewController
@property (nonatomic, strong, readonly) RCLVHostPresenter *presenter;
@property (nonatomic, strong, readonly) RCUserListView *userListView;
@property (nonatomic, strong, readonly) CreateRoomModel *roomInfo;
@property (nonatomic, strong) UIAlertController *alert; // PK邀请弹窗

- (void)updatePKStatus:(BOOL)isPK;

@end

NS_ASSUME_NONNULL_END
