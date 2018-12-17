//
//  User.h
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/17.
//  Copyright © 2018 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
+(instancetype)share;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *token;
- (NSString*)uniqueDeviceToken;
-(NSString *)getGMTString;
@end

NS_ASSUME_NONNULL_END
