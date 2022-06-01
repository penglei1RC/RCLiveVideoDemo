//
//  RCLVSeatItemView.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/30.
//

#import "RCLVSeatItemView.h"

@interface RCLVSeatItemView ()<RCLiveVideoSeatDelegate>

@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *muteImageView;
@property (nonatomic, strong) UILabel *micIndexLabel;
@property (nonatomic, strong) UIVisualEffectView *blurView;

@end

@implementation RCLVSeatItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    
    [self addSubview:self.blurView];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.addImageView];
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(@(CGSizeMake(56, 56)));
    }];
    
    [self addSubview:self.lockImageView];
    [self.lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.addImageView);
        make.size.equalTo(@(CGSizeMake(56, 56)));
    }];

    
    [self addSubview:self.muteImageView];
    [self.muteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
    }];
    
    [self addSubview:self.micIndexLabel];
    [self.micIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addImageView.mas_bottom).offset(8);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
    
}

- (void)tapView {
    !self.handler ?: self.handler();
}

#pragma mark - public method
- (void)setSeatInfo:(RCLiveVideoSeat *)seatInfo {
    _seatInfo = seatInfo;
    if (seatInfo.userId.length != 0) {
        [self configUserUI];
    } else {
        [self configNoUserUI];
    }
    seatInfo.delegate = self;
}

#pragma mark - RCLiveVideoSeatDelegate
/// 麦位锁定状态更新
/// @param seat 麦位
/// @param isLocked 是否锁定
- (void)seat:(RCLiveVideoSeat *)seat didLock:(BOOL)isLocked {
    self.seatInfo = seat;
}

/// 麦位静音状态更新
/// @param seat 麦位
/// @param isMuted 是否静音
- (void)seat:(RCLiveVideoSeat *)seat didMute:(BOOL)isMuted {
    self.seatInfo = seat;
}

/// 麦位用户音频状态更新
/// @param seat 麦位
/// @param enable 是否开启
- (void)seat:(RCLiveVideoSeat *)seat didUserEnableAudio:(BOOL)enable {
    self.seatInfo = seat;
}

/// 麦位用户视频状态更新
/// @param seat 麦位
/// @param enable 是否开启
- (void)seat:(RCLiveVideoSeat *)seat didUserEnableVideo:(BOOL)enable {
    self.seatInfo = seat;
}

/// 麦位声音状态更新
/// @param seat 麦位
/// @param audioLevel 声音大小
- (void)seat:(RCLiveVideoSeat *)seat didSpeak:(NSInteger)audioLevel {
    self.seatInfo = seat;
//    Log(@"RCLiveVideoSeat seat audioLevel: %ld",audioLevel);
}

#pragma mark - private method
- (void)configUserUI {
    self.backgroundColor = [UIColor clearColor];
    self.micIndexLabel.hidden = YES;
    self.muteImageView.hidden = !self.seatInfo.mute;
    self.lockImageView.hidden = !self.seatInfo.lock;

    self.blurView.hidden = self.seatInfo.userEnableVideo;
    self.addImageView.hidden = (self.seatInfo.userEnableAudio && !self.seatInfo.lock);
    self.addImageView.image = [UIImage imageNamed:@"avatar1"];

}

- (void)configNoUserUI {
    self.backgroundColor = [UIColor colorWithRed:49/255.0 green:51/255.0 blue:99/255.0 alpha:1.0];
    self.blurView.hidden = YES;
    self.addImageView.image = [UIImage imageNamed:@"live_seat_add"];
    self.addImageView.hidden = self.seatInfo.lock;
    self.micIndexLabel.hidden = self.seatInfo.lock;
    self.lockImageView.hidden = !self.seatInfo.lock;
    self.muteImageView.hidden = !self.seatInfo.mute;
}

#pragma mark - lazy load
- (UIVisualEffectView *)blurView {
    if (!_blurView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        _blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _blurView;
}

- (UIImageView *)addImageView {
    if (!_addImageView) {
        _addImageView = [[UIImageView alloc] init];
        _addImageView.layer.cornerRadius = 28;
        _addImageView.image = [UIImage imageNamed:@"live_seat_add"];
        _lockImageView.contentMode = UIViewContentModeCenter;
        _addImageView.clipsToBounds = YES;
    }
    return _addImageView;
}

- (UIImageView *)lockImageView {
    if (!_lockImageView) {
        _lockImageView = [[UIImageView alloc] init];
        _lockImageView.image = [UIImage imageNamed:@"lock_seat_icon"];
        _lockImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _lockImageView;
}

- (UIImageView *)muteImageView {
    if (!_muteImageView) {
        _muteImageView = [[UIImageView alloc] init];
        _muteImageView.image = [UIImage imageNamed:@"mute_microphone_icon"];
    }
    return _muteImageView;
}

- (UILabel *)micIndexLabel {
    if (!_micIndexLabel) {
        _micIndexLabel = [[UILabel alloc] init];
        _micIndexLabel.textColor = [UIColor whiteColor];
        _micIndexLabel.font = [UIFont systemFontOfSize:12 weight: UIFontWeightRegular];
        _micIndexLabel.textAlignment = NSTextAlignmentCenter;
        _micIndexLabel.text = @"邀请连线";
    }
    return _micIndexLabel;
}

@end
