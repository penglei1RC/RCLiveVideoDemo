//
//  RCWebService+PK.m
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/31.
//

#import "RCWebService+PK.h"

@implementation RCWebService (PK)

+ (void)pk_roomOnlineCreatedListWithResponseClass:(nullable Class)responseClass
                                          success:(nullable LVSSuccessCompletion)success
                                          failure:(nullable LVSFailureCompletion)failure {
    [[self shareInstance] GET:np_fetch_online_creator parameters:@{@"roomType":@(1)} auth:YES responseClass:responseClass success:success failure:failure];
}


+ (void)pk_syncPKStateWithRoomId:(NSString *)roomId
                          status:(NSInteger)status
                        toRoomId:(NSString *)toRoomId
                   responseClass:(nullable Class)responseClassm
                         success:(nullable LVSSuccessCompletion)success
                         failure:(nullable LVSFailureCompletion)failure {
    NSDictionary *params = @{@"roomId":roomId, @"status":@(status), @"toRoomId":toRoomId};
    [[self shareInstance] POST:np_sync_pk_state parameters:params auth:YES responseClass:responseClassm success:success failure:failure];
}

+ (void)pk_checkRoomType:(NSString *)roomId
           responseClass:(nullable Class)responseClassm
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure {
    NSString *path = [NSString stringWithFormat:np_check_room_type_isPk, roomId];
    [[self shareInstance] GET:path parameters:nil auth:YES responseClass:responseClassm success:success failure:failure];
}

+ (void)pk_fetchPKDetail:(NSString *)roomId
           responseClass:(nullable Class)responseClassm
                 success:(nullable LVSSuccessCompletion)success
                 failure:(nullable LVSFailureCompletion)failure {
    NSString *path = [NSString stringWithFormat:np_fetch_pk_detail, roomId];
    [[self shareInstance] GET:path parameters:nil auth:YES responseClass:responseClassm success:success failure:failure];
}

@end
