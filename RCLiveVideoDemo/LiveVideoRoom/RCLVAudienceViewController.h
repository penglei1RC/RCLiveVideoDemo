//
//  RCLVAudienceViewController.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <UIKit/UIKit.h>
#import "RCLVAudiencePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVAudienceViewController : UIViewController

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, strong, readonly) RCLVAudiencePresenter *presenter;

- (void)updatePKStatus:(BOOL)isPK;

@end

NS_ASSUME_NONNULL_END
