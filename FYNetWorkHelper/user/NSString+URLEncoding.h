//
//  NSString+URLEncoding.h
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/17.
//  Copyright © 2018 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLEncoding)
- (NSString*)md5Hash;
- (BOOL) isNonEmpty;
- (NSString*) urlPathWithCommonStat;//拼接URL的字符串
+ (NSString *) commonStatString;
@end

NS_ASSUME_NONNULL_END
