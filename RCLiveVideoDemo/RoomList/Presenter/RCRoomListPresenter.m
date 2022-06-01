//
//  RCRoomListPresenter.m
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/20.
//

#import "RCRoomListPresenter.h"
#import <CommonCrypto/CommonDigest.h>

@interface RCRoomListPresenter()
@property (nonatomic, copy, readwrite) NSArray<RoomListRoomModel *> *dataModels;
@end

@implementation RCRoomListPresenter

- (instancetype)init {
    if (self = [super init]) {
        self.dataModels = @[];
    }
    return self;
}

- (void)fetchRoomListWithCompletionBlock:(void(^)(RCResponseType type))completionBlock {
    [RCWebService roomListWithSize:20
                            page:0
                            type:LVSRoomTypeVideo
                   responseClass:[RoomListModel class]
                         success:^(id  _Nullable responseObject) {
        RCResponseModel *res = (RCResponseModel *)responseObject;
        if (res.code.integerValue != StatusCodeSuccess) {
            completionBlock(RCResponseTypeSeverError);
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"房间数据获取失败 code:%d",res.code.intValue]];
            return ;
        }
        
        RoomListModel *model = (RoomListModel *)res.data;
        self.dataModels = model.rooms;
        BOOL isNoData = (self.dataModels.count == 0);
        !completionBlock ?: completionBlock(isNoData ? RCResponseTypeNoData : RCResponseTypeNormal);
        
    } failure:^(NSError * _Nonnull error) {
        
        BOOL isOffline = NO; // 判断是否无网络
        !completionBlock ?: completionBlock(isOffline ? RCResponseTypeOffline : RCResponseTypeSeverError);
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"房间数据获取失败 code:%ld",(long)error.code]];
    }];
}

@end
