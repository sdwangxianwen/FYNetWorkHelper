//
//  NSString+URLEncoding.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/17.
//  Copyright © 2018 wang. All rights reserved.
//

#import "NSString+URLEncoding.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "User.h"

@implementation NSData(category)

- (NSString*)md5Hash {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
     CC_MD5([self bytes], [self length], result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation NSString (URLEncoding)

- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString*) urlPathWithCommonStat {
    // 如果是空字符串，则返回空字符串本身
    if (![self isNonEmpty]) {
        return self;
    }
    NSString* commonStat = [[self class] commonStatString];
    // 已经带有统计信息了
    if ([self rangeOfString:commonStat].length > 0) {
        return self;
    }
    
    // 添加统计信息
    if ([self rangeOfString:@"?"].length > 0) {
        return [self stringByAppendingFormat:@"&%@", commonStat];
    } else {
        return [self stringByAppendingFormat:@"?%@", commonStat];
    }
}
//phoneType,systemVer,appVer,channel,deviceType,deviceId
+ (NSString *) commonStatString {
    NSString *ver = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    // platform: 和发布的app的platform的定义一致: iPad, iPhone, android, 如果需要统计真实的platform, 可以考虑添加其他的参数
//    return [NSString stringWithFormat: @"phoneType=%@&systemVer=%@&appVer=%@&channel=%@&deviceType=%@&deviceId=%@",
//            @"ios",
//            [[UIDevice currentDevice] systemVersion],
//            ver,
//            @"AppStore",
//            [[UIDevice currentDevice] model],
//            [[User share] uniqueDeviceToken] // 用于数据的统计
//            ];
    
    return [NSString stringWithFormat: @"phoneType=%@&systemVer=%@&version=%@&channel=%@&deviceType=%@&deviceId=%@&timeZone=%@",
            @"ios",
            [[UIDevice currentDevice] systemVersion],
            ver,
            @"AppStore",//[AppDelegate appDelegate].vendor,
            [[UIDevice currentDevice] model],
            [[User share] uniqueDeviceToken], // 用于数据的统计
            [[User share] getGMTString]
            ];
}


static NSMutableCharacterSet* emptyStringSet = nil;
- (BOOL) isNonEmpty {
    if (emptyStringSet == nil) {
        emptyStringSet = [[NSMutableCharacterSet alloc] init];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [emptyStringSet formUnionWithCharacterSet: [NSCharacterSet characterSetWithCharactersInString: @"　"]];
    }
    
    if ([self length] == 0) {
        return NO;
    }
    
    NSString* str = [self stringByTrimmingCharactersInSet:emptyStringSet];
    return [str length] > 0;
}

@end
