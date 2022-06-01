//
//  RCLVHostViewController+PK.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCLVHostViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCLVHostViewController (PK)

- (void)pk_loadPKModule;
- (void)pk_invite:(BOOL)isInvite;

@end

NS_ASSUME_NONNULL_END
