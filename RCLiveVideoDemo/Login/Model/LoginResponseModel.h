//
//  LoginResponseModel.h
//  RCLiveVideoDemo
//
//  Created by 彭蕾 on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginResponseModel : NSObject

@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, copy)   NSString *userName;
@property (nonatomic, copy)   NSString *portrait;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy)   NSString *authorization;
@property (nonatomic, copy)   NSString *imToken;
@property (nonatomic, copy)   NSString *phone;

@end

NS_ASSUME_NONNULL_END
