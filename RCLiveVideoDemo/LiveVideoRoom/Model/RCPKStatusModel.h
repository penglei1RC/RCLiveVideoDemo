//
//  RCPKStatusModel.h
//  RCVoiceRoomDemo
//
//  Created by 彭蕾 on 2022/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCPKStatusRoomScore;

@interface RCPKStatusModel : NSObject

@property (nonatomic, assign) NSInteger statusMsg; // pk 状态,0:PK中,1:惩罚中，2:PK结束
@property (nonatomic, assign) NSInteger timeDiff;
@property (nonatomic, strong) NSArray<RCPKStatusRoomScore *> *roomScores;

@end

@interface RCPKStatusRoomScore : NSObject

@property (nonatomic, assign) BOOL leader;
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSArray<UserModel *> *userInfoList;

@end


NS_ASSUME_NONNULL_END
