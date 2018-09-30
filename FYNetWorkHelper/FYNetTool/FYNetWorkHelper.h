//
//  FYNetWorkHelper.h
//  FYNetWorkHelper
//
//  Created by wang on 2018/9/30.
//  Copyright © 2018 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id);
typedef void(^failureBlock)(id);

NS_ASSUME_NONNULL_BEGIN

@interface FYNetWorkHelper : NSObject

+(instancetype)shared;

-(void)get:(NSString *)url parm:(id)parm isCache:(BOOL)isCache success:(successBlock)success failure:(failureBlock)failure;

@end

NS_ASSUME_NONNULL_END
