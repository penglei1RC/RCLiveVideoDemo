//
//  RCLVRoomActionView.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVRoomActionView.h"

@interface RCLVRoomActionView ()

@property (nonatomic, copy) NSArray<NSNumber *> *types;
@property (nonatomic, strong) UIButton *pkButton;

@end

#define RCLVRoomActionViewTagMask (10000)
@implementation RCLVRoomActionView
- (instancetype)initWithTypes:(NSArray<NSNumber *> *)types {
    if (self = [super init]) {
        self.types = types;
        [self buildLayout];
    }
    return self;
}

- (void)setIsPK:(BOOL)isPK {
    _isPK = isPK;
    self.pkButton.selected = isPK;
}

- (void)buildLayout {
    self.backgroundColor = mainColor;
    
    CGFloat btnHeight = 40.0f;
    CGFloat btnSpace = 10.0f;
    NSUInteger btnColum = 4;
    CGFloat btnWidth = (kScreenWidth - btnSpace*(btnColum + 1))/btnColum;
        
    for (int i = 0; i < _types.count; i++) {
        RCLVRoomActionType type = self.types[i].unsignedIntegerValue;
        NSString *btnTitle = [self titleWithType:type];
        UIButton *btn = [self createActionBtn];
        if (type == RCLVRoomActionTypePK) {
            [btn setTitle:@"取消PK" forState:UIControlStateSelected];
            self.pkButton = btn;
        }
        CGFloat x = btnSpace + (i % btnColum) * (btnSpace + btnWidth);
        CGFloat y = btnSpace + (i / btnColum) * (btnSpace + btnHeight);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        btn.tag = RCLVRoomActionViewTagMask + type;
        btn.frame = CGRectMake(x, y, btnWidth, btnHeight);
        [self addSubview:btn];
    }
    
}

- (void)btnAction:(UIButton *)btn {
    RCLVRoomActionType type = btn.tag - RCLVRoomActionViewTagMask;
    btn.selected = !btn.isSelected;
    !_hander ?: _hander(type, btn.isSelected);
}

- (UIButton *)createActionBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    return btn;
}

- (NSString *)titleWithType:(RCLVRoomActionType )type {
    switch (type) {
        case RCLVRoomActionTypeAudienceRequest:
            return @"申请上麦";
        case RCLVRoomActionTypeAudienceCancelRequest:
            return @"取消申请";
        case RCLVRoomActionTypeHostInvite:
            return @"邀请上麦列表";
        case RCLVRoomActionTypeHostCancelInvite:
            return @"取消邀请";
        case RCLVRoomActionTypeGetRoomUsers:
            return @"观众列表";
        case RCLVRoomActionTypeGetRequestList:
            return @"申请列表";
        case RCLVRoomActionTypePK:
            return @"发起PK";
        case RCLVRoomActionTypeLeaveRoom:
            return @"结束直播";
        case RCLVRoomActionTypeLeaveFinishLive:
            return @"结束连麦";
        case RCLVRoomActionTypeSetMixType:
            return @"设置浮窗布局";
        case RCLVRoomActionTypeSetNotice:
            return @"设置公告";
        default:
            return @"default";
            break;
    }
}

@end
