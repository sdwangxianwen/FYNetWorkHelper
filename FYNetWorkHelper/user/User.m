//
//  User.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/17.
//  Copyright © 2018 wang. All rights reserved.
//

#import "User.h"
#import "NSString+URLEncoding.h"
#import <SNSFHFKeychainUtils/SFHFKeychainUtils.h>

@implementation User
+ (instancetype)share {
    static dispatch_once_t onceToken;
    static User *user;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    return user;
}

//获取token
- (NSString*)uniqueDeviceToken {
    @synchronized(self) {
        NSString* uniqueDeviceToken = [self __uniqueDeviceToken];
        return uniqueDeviceToken;
    }
}

-(NSString*) getUUID {
    static NSString *UUIDString = nil;
    if ([UUIDString isNonEmpty]) {
        return UUIDString;
    }

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        UUIDString = [[NSUUID UUID] UUIDString];
    } else {
        CFUUIDRef UUID = CFUUIDCreate(NULL);
        UUIDString = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
    }
    
    UUIDString = [UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (![UUIDString isNonEmpty]) {
        return @"";
    } else {
        return UUIDString;
    }
}

- (NSString*) __uniqueDeviceToken {
    static NSString* kDeviceToken = @"SC_DV_TOKEN";
    static NSString* kServiceName = @"SC_SERVICE";
    
    // 1. 首先读取新的Token
    NSString* tokenV2 = [SFHFKeychainUtils getPasswordForUsernameV2: kDeviceToken
                                                     andServiceName: kServiceName
                                                              error: nil];
    
    // 2.1. 如果读取成功，则返回:
    if ([tokenV2 isNonEmpty]) {
        return tokenV2;
    }
    
    // 生成一个UUID(不是设备相关的)
    NSString* uuid = [self getUUID];
    uuid =  [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [SFHFKeychainUtils storeUsername: kDeviceToken
                         andPassword: uuid
                      forServiceName: kServiceName
                      updateExisting: YES error: nil];
    return uuid;
}

-(NSString *)getGMTString {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLocal = [userDefaults boolForKey:IS_LOCALTIME_ZONE];
    NSTimeZone *zone = [self getTimeZone];
    if (isLocal) {
        NSInteger seconds = zone.secondsFromGMT/3600;
        if (seconds == 0) {//0时区特殊处理
            return  @"GMT+0";
        }
        return [zone localizedName:NSTimeZoneNameStyleShortStandard locale:nil];
    } else {
        return [zone.name stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
}

-(NSTimeZone *)getTimeZone {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLocal = [userDefaults boolForKey:IS_LOCALTIME_ZONE];
    if (isLocal) {
        return [NSTimeZone systemTimeZone];//系统默认时区
    } else {
        return [NSTimeZone timeZoneForSecondsFromGMT:8*60*60];//东八区
    }
}

@end
