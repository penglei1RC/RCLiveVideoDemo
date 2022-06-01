//
//  RCLVPKView.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/6/1.
//

#import "RCLVPKView.h"

@interface RCLVPKView ()

@property (nonatomic, strong) UIButton *muteUserBtn;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign) BOOL isHost;
@end

@implementation RCLVPKView

- (instancetype)initWithHost:(BOOL)isHost {
    if (self = [super init]) {
        self.isHost = isHost;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    if (!_isHost) {
        return ;
    }
    
    [self addSubview:self.muteUserBtn];
    [self.muteUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(self).offset(-10);
    }];
}

- (void)muteBtnClicked:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    !_handler ?: _handler(btn.isSelected);
}

#pragma mark - lazy load
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.font = [UIFont systemFontOfSize:25 weight: UIFontWeightRegular];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"PK中";
    }
    return _tipsLabel;
}

- (UIButton *)muteUserBtn {
    if (!_muteUserBtn) {
        _muteUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _muteUserBtn.backgroundColor = [UIColor systemPinkColor];
        _muteUserBtn.layer.cornerRadius = 6;
        _muteUserBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_muteUserBtn setTitle:@"闭麦" forState: UIControlStateNormal];
        [_muteUserBtn setTitle:@"解除闭麦" forState: UIControlStateSelected];
        [_muteUserBtn setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        [_muteUserBtn addTarget:self action:@selector(muteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteUserBtn;
}

@end
