//
//  RCLVSeatItemView.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define RCLVSeatItemViewTagMask (10000)
typedef void(^RCLVSeatItemViewTapHandler)(void);

@interface RCLVSeatItemView : UIView

@property (nonatomic, strong) RCLVSeatItemViewTapHandler handler;
@property (nonatomic, strong) RCLiveVideoSeat *seatInfo;

@end

NS_ASSUME_NONNULL_END
