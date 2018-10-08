//
//  FYNetWorkHelper.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/9/30.
//  Copyright © 2018 wang. All rights reserved.
//

#import "FYNetWorkHelper.h"
#import "PPNetworkHelper.h"

@implementation FYNetWorkHelper
+(instancetype)shared {
    static dispatch_once_t onceToken;
    static FYNetWorkHelper *net = nil;
    dispatch_once(&onceToken, ^{
        net = [[FYNetWorkHelper alloc] init];
    });
    return net;
}

-(void)get:(NSString *)url parm:(id)parm isCache:(BOOL)isCache success:(successBlock)success failure:(failureBlock)failure {
    
    if (isCache) {
        //需要缓存
        [PPNetworkHelper GET:url parameters:parm responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            id cache = [PPNetworkCache httpCacheForURL:url parameters:parm];
            failure ?(cache != nil ? failure(cache): failure(error)) : nil;
        }];
    }  else {
        //不需要缓存
        [PPNetworkHelper GET:url parameters:parm success:^(id responseObject) {
            success(responseObject);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    
    
}
@end
