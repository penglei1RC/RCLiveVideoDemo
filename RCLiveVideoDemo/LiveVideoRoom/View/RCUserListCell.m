//
//  RCUserListCell.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/23.
//

#import "RCUserListCell.h"

@interface RCUserListCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIStackView *stackView;

/// 用户交互按钮
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *rejectButton;
@property (nonatomic, strong) UIButton *kickButton;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *cancelInviteButton;
@property (nonatomic, strong) UIButton *invitePKButton;
@property (nonatomic, strong) UIButton *cancelInvitePKButton;


@end

#define CELL_BTN_ACTION_TAG (1000)
@implementation RCUserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self UIConfig];
    }
    return self;
}

- (void)UIConfig {
    
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(26);
        make.left.equalTo(self.contentView).offset(16);
    }];
    
    [self.contentView addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
    }];
    
    [self.contentView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idLabel.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).inset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.contentView.mas_bottom).inset(16);
    }];
    
}

#pragma mark - public method
- (void)updateCellWithUser:(UserModel *)user {
    self.nameLabel.text = [NSString stringWithFormat:@"%@",user.userName];
    self.idLabel.text = [NSString stringWithFormat:@"%@",user.userId];
}

- (void)setCellStyle:(RCUserListCellStyle)cellStyle {
    switch (cellStyle) {
        case RCUserListCellStyleKick:
        {
            self.agreeButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.kickButton.hidden = NO;
            self.inviteButton.hidden = NO;
            self.cancelInviteButton.hidden = YES;
            self.cancelInvitePKButton.hidden = YES;
            self.invitePKButton.hidden = YES;
        }
            break;
        case RCUserListCellStyleRequest:
        {
            self.agreeButton.hidden = NO;
            self.rejectButton.hidden = NO;
            self.kickButton.hidden = YES;
            self.inviteButton.hidden = YES;
            self.cancelInviteButton.hidden = YES;
            self.cancelInvitePKButton.hidden = YES;
            self.invitePKButton.hidden = YES;

        }
            break;
        case RCUserListCellStyleCancelInvite:
        {
            self.agreeButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.kickButton.hidden = YES;
            self.inviteButton.hidden = YES;
            self.cancelInviteButton.hidden = NO;
            self.cancelInvitePKButton.hidden = YES;
            self.invitePKButton.hidden = YES;
        }
            break;
        case RCUserListCellStylePKCreator:
        {
            self.agreeButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.kickButton.hidden = YES;
            self.inviteButton.hidden = YES;
            self.cancelInviteButton.hidden = YES;
            self.cancelInvitePKButton.hidden = NO;
            self.invitePKButton.hidden = NO;
        }
            break;

            
        default:
        {
            self.agreeButton.hidden = YES;
            self.rejectButton.hidden = YES;
            self.kickButton.hidden = YES;
            self.inviteButton.hidden = YES;
            self.cancelInviteButton.hidden = YES;
            self.cancelInvitePKButton.hidden = YES;
            self.invitePKButton.hidden = YES;
        }
            
            break;
    }
}

#pragma mark - lazy load
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    }
    return _nameLabel;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.font = [UIFont systemFontOfSize:14];
    }
    return _idLabel;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = 6;
        _stackView.alignment = UIStackViewAlignmentTrailing;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        
        self.agreeButton = [self actionButtonFactory:@"同意" withActionType:RCUserListCellActionTypeAgree];
        self.rejectButton = [self actionButtonFactory:@"拒绝" withActionType:RCUserListCellActionTypeReject];
        self.kickButton = [self actionButtonFactory:@"踢出" withActionType:RCUserListCellActionTypeKick];
        self.inviteButton = [self actionButtonFactory:@"邀请" withActionType:RCUserListCellActionTypeInvite];
        self.cancelInviteButton = [self actionButtonFactory:@"取消邀请" withActionType:RCUserListCellActionTypeCancelInvite];
        self.invitePKButton = [self actionButtonFactory:@"邀请PK" withActionType:RCUserListCellActionTypePKInvite];
        self.cancelInvitePKButton = [self actionButtonFactory:@"取消PK邀请" withActionType:RCUserListCellActionTypePKCancel];
        
        [_stackView addArrangedSubview:self.agreeButton];
        [_stackView addArrangedSubview:self.rejectButton];
        [_stackView addArrangedSubview:self.kickButton];
        [_stackView addArrangedSubview:self.inviteButton];
        [_stackView addArrangedSubview:self.cancelInviteButton];
        [_stackView addArrangedSubview:self.invitePKButton];
        [_stackView addArrangedSubview:self.cancelInvitePKButton];
    }
    return _stackView;
}

- (UIButton *)actionButtonFactory:(NSString *)title withActionType:(RCUserListCellActionType )type {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor systemPinkColor];
    button.layer.cornerRadius = 6;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:title forState: UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    button.tag = CELL_BTN_ACTION_TAG + type;
    [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[button.widthAnchor constraintGreaterThanOrEqualToConstant:70] setActive:YES];
    return button;
}

- (void)btnClicked:(UIButton *)btn {
    RCUserListCellActionType type = btn.tag - CELL_BTN_ACTION_TAG;
    !_handler ?: _handler(type);
}



@end
