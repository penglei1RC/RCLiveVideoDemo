//
//  RCUserListView.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/23.
//

#import "RCUserListView.h"
#import "RCUserListCell.h"
//#import "RCOnlineCreatorModel.h"

@interface RCUserListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<UserModel *> *users;
@property (nonatomic, assign) BOOL isHost;

@end

static NSString *userListIdetifier = @"RCUserListCell";
@implementation RCUserListView

- (instancetype)initWithCreate:(BOOL)isCreate {
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 20.0f;
        self.layer.borderColor = mainColor.CGColor;
        self.layer.borderWidth = 1.f;
        self.isHost = isCreate;
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout {
    [self addSubview:self.topBar];
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44.f);
        make.leading.trailing.top.equalTo(self);
    }];
    
    [self.topBar addSubview:self.dismissButton];
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.topBar);
        make.width.mas_equalTo(44.f);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.bottom.trailing.leading.equalTo(self);
    }];

}

#pragma mark - public methods
- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x,
                                (kScreenHeight - self.frame.size.height)/2,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x,
                                kScreenHeight,
                                self.frame.size.width,
                                self.frame.size.height);
    }];
}

- (void)reloadData:(NSArray<UserModel *> *)users {
    self.users = users;
    [self.tableView reloadData];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:userListIdetifier];
    UserModel *user = self.users[indexPath.row];
    [cell updateCellWithUser:user];
    
    cell.handler = ^(RCUserListCellActionType type) {
        [self dismiss];
        if ([user isKindOfClass:[RCOnlineCreatorModel class]]) {
            RCOnlineCreatorModel *creator = (RCOnlineCreatorModel *)user;
            !self.handler ?: self.handler(user.userId, creator.roomId, type);
        } else {
            !self.handler ?: self.handler(user.userId, nil, type);
        }
    };
    
    if (!self.isHost) {
        cell.cellStyle = RCUserListCellStyleDefault;
        return cell;
    }
    
    switch (self.listType) {
        case RCUserListTypeRoomUser:
            cell.cellStyle = RCUserListCellStyleKick;
            break;
        case RCUserListTypeRoomInvite:
            cell.cellStyle = RCUserListCellStyleCancelInvite;
            break;
        case RCUserListTypeRoomCreator:
            cell.cellStyle = RCUserListCellStylePKCreator;
            break;
        case RCUserListTypeRequest:
            cell.cellStyle = RCUserListCellStyleRequest;
            break;
            
        default:
            cell.cellStyle = RCUserListCellStyleDefault;
            break;
    }
    return cell;
    
}

#pragma mark - lazy load
- (UIView *)topBar {
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = mainColor;
    }
    return _topBar;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.backgroundColor = mainColor;
        [_dismissButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_dismissButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = (id)self;
        _tableView.dataSource = (id)self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 220;
        [_tableView registerClass:[RCUserListCell class] forCellReuseIdentifier:userListIdetifier];
    }
    return _tableView;
}

- (NSArray<UserModel *> *)users {
    if (!_users) {
        _users = [NSArray new];
    }
    return _users;
}
@end
