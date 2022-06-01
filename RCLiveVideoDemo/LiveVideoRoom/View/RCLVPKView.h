//
//  RCLVPKView.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/6/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RCLVPKViewActionHandler)(BOOL isSelected);

@interface RCLVPKView : UIView

- (instancetype)initWithHost:(BOOL)isHost;
@property (nonatomic, copy) RCLVPKViewActionHandler handler;

@end

NS_ASSUME_NONNULL_END
