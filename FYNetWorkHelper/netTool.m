//
//  netTool.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/14.
//  Copyright © 2018 wang. All rights reserved.
//

#import "netTool.h"
#import "FYNetTool/FYNetWorkHelper.h"
#import <YYModel.h>
#import <SVProgressHUD.h>
#import "user/User.h"
#import "user/NSString+URLEncoding.h"

static inline NSString* ENSURE_NOT_NULL(id src) {
    return src ? src : @"";
}

@implementation netTool
+(instancetype)share {
    static dispatch_once_t onceToken;
    static netTool *tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    
    });
    return tool;
}

NSString *GET_STRING(id originData) {
    if ([originData isKindOfClass: [NSString class]]) {
        return originData;
    }else if (!originData || [originData isKindOfClass: [NSNull class]]) {
        return @"";
    } else {
        return [NSString stringWithFormat: @"%@", originData];
    }
}

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding string:(NSString *)string {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:string];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        } else if (kvPair.count > 2) {
            
            NSRange range = [pairString rangeOfString:@"="];
            NSString *key = [[pairString substringToIndex:range.location] stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString *value = [[pairString substringFromIndex:range.location + 1] stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString*)stringByAddingQueryDictionary:(NSDictionary*)query {
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [[query allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare: obj2];
    }]) {
        NSString* value = GET_STRING([query objectForKey:key]);
        NSString* pair = [NSString stringWithFormat:@"%@=%@", key, value];
        [pairs addObject:pair];
    }
    
    NSString* params = [pairs componentsJoinedByString:@"&"];
    
    return params;
}

-(void)get:(NSString *)url parm:(NSDictionary *)parm modelClass:(Class)modelClass isCache:(BOOL)isCache isShowLoadHUD:(BOOL)isShowLoadHUD isShowErrorHUD:(BOOL)isShowErrorHUD success:(successBlock)success {
    if (isShowLoadHUD) {
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    NSString *urlString = [NSString stringWithFormat:@"https://appteai.51talk.com/%@",url];
    urlString = [urlString stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
    [FYNetworkHelper setRequestSerializer:(FYRequestSerializerHTTP)];
    [FYNetworkHelper setRequestTimeoutInterval:0.5];
    [FYNetworkHelper GET:urlString parameters:parm isCache:isCache success:^(id responseObject) {
        if (isShowLoadHUD) {
            [SVProgressHUD dismiss];
        }
        NetModel *baseModel = [NetModel yy_modelWithJSON:responseObject];
        NSLog(@"%@",baseModel.message);
        if (baseModel.code == 10000) {
            //成功的回调
            NetModel *model = [[modelClass class] yy_modelWithJSON:responseObject[@"data"]];
            success(model);
        } else {
            //重试,展示错误信息
            [SVProgressHUD showErrorWithStatus:baseModel.message];
            NSLog(@"%@",baseModel.message);
        }
      
        
    } failure:^(NSError *error, id cacheReponse) {
        if (isShowLoadHUD) {
            [SVProgressHUD dismiss];
        }
        //网络错误,展示缓存内容
        if (isShowErrorHUD) {
            [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
        }
        if (isCache) {
            NetModel *model = [[modelClass class] yy_modelWithJSON:cacheReponse[@"data"]];
            success(model);
        }
    }];
}


-(void)post:(NSString *)url parm:(NSDictionary *)parm modelClass:(Class)modelClass isCache:(BOOL)isCache isShowLoadHUD:(BOOL)isShowLoadHUD isShowErrorHUD:(BOOL)isShowErrorHUD success:(successBlock)success {
    if (isShowLoadHUD) {
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    NSString *urlString = [NSString stringWithFormat:@"https://appteai.51talk.com/%@",url];
    NSString *newURLString = [urlString urlPathWithCommonStat];
    NSURL *newURL = [NSURL URLWithString:newURLString];
    NSDictionary *getQuery = [self queryDictionaryUsingEncoding:NSUTF8StringEncoding string:newURL.query];
    NSMutableDictionary *mutaDict = [NSMutableDictionary dictionaryWithDictionary: getQuery];
    if (!!parm) {
        [mutaDict addEntriesFromDictionary: parm];
    }
    if (![parm[kIgnoreUserId] boolValue]) {
        mutaDict[@"userId"] = ENSURE_NOT_NULL([User share].userId);
        mutaDict[@"token"] = ENSURE_NOT_NULL([User share].token);
    }
    
    // 去掉value是字符串且字符串为空的参数
    NSMutableDictionary *mutableQuery = [NSMutableDictionary dictionary];
    for (NSString* key in [mutaDict allKeys]) {
        NSString* value = GET_STRING([mutaDict objectForKey:key]);
        if ([value isNonEmpty]) {
            mutableQuery[key] = value;
        }
    }
    //签名加密
    NSString *queryString = [self stringByAddingQueryDictionary: mutableQuery];
    NSString *signString = [queryString stringByAppendingString:@"!08za$8gQKZCt^ME"];
    NSString *sign = [[signString md5Hash] uppercaseString];
    NSMutableDictionary *queryWithSign = [NSMutableDictionary dictionaryWithDictionary: parm];
    // 统计用的一些参数没必要加入到post body中，所以userID和token也没加进去，需要加一下
    if (![parm[kIgnoreUserId] boolValue]) {
        User *user = [User share];
        queryWithSign[@"userId"] = ENSURE_NOT_NULL(user.userId);
        queryWithSign[@"talk_token"] = ENSURE_NOT_NULL(user.token);
    }
     queryWithSign[@"tsign"] = ENSURE_NOT_NULL(sign);
    
    // 因为url中有 GMT+8 这样的字段，需要额外处理 + ；否则IOS URL无法对加号进行编码导致http请求时服务器端获取的内容中加号会变成空格
    newURLString = [newURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%<>[\\]^`{|}\"]+"].invertedSet];
    [FYNetworkHelper setRequestTimeoutInterval:0.5];
    [FYNetworkHelper setRequestSerializer:(FYRequestSerializerHTTP)];
    [FYNetworkHelper POST:newURLString parameters:queryWithSign isCache:YES success:^(id responseObject) {
        if (isShowLoadHUD) {
            [SVProgressHUD dismiss];
        }
        NetModel *baseModel = [NetModel yy_modelWithJSON:responseObject];
        NSLog(@"%@",baseModel.message);
        if (baseModel.code == 100000) {
            //成功的回调
            [SVProgressHUD showSuccessWithStatus:baseModel.message];
            NetModel *model = [[modelClass class] yy_modelWithJSON:responseObject[@"data"]];
            success(model);
        } else {
            //重试,展示错误信息
            [SVProgressHUD showErrorWithStatus:baseModel.message];
            NSLog(@"%@",baseModel.message);
        }
    } failure:^(NSError *error, id cacheReponse) {
        if (isShowLoadHUD) {
            [SVProgressHUD dismiss];
        }
        //网络错误,展示缓存内容
        if (isShowErrorHUD) {
            [SVProgressHUD showErrorWithStatus:@"网络连接超时"];
        }
        if (isCache) {
            NetModel *model = [[modelClass class] yy_modelWithJSON:cacheReponse[@"data"]];
            success(model);
        }
    }];
    
}

@end
