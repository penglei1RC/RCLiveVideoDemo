//
//  RCLVRoomInfoView.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import "RCLVRoomInfoView.h"

@interface RCLVRoomInfoView ()

@property (nonatomic, strong) UILabel *desLabel;

@end

@implementation RCLVRoomInfoView
- (instancetype)init {
    if (self = [super init]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)updateUIWith:(CreateRoomModel *)model {
    self.desLabel.text = [NSString stringWithFormat:
                          @"房间名：%@\n\n房间ID：%@\n\n用户名：%@\n\n用户ID：%@\n\n登录手机号：%@",
                          model.roomName,model.roomId,
                          [RCUserManager userName],
                          [RCUserManager uid],
                          [RCUserManager phone]];
}

#pragma mark - lazy load
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.numberOfLines = 0;
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textColor = mainColor;
        _desLabel.userInteractionEnabled = YES;
    }
    return _desLabel;
}


@end
