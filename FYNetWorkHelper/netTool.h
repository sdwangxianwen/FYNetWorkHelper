//
//  netTool.h
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/14.
//  Copyright © 2018 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetModel.h"

typedef void(^successBlock)(id response);


NS_ASSUME_NONNULL_BEGIN

@interface netTool : NSObject
+(instancetype)share;



/**
 get请求,不需要签名

 @param url 请求地址
 @param parm 请求参数
 @param modelClass 请求返回的模型类型
 @param isCache 是否需要缓存s
 @param isShowLoadHUD 是否显示加载HUD
 @param isShowErrorHUD 是否显示错误HUD
 @param success 成功的回调
 */
-(void)get:(NSString *)url parm:(NSDictionary *)parm modelClass:(Class)modelClass isCache:(BOOL)isCache isShowLoadHUD:(BOOL)isShowLoadHUD isShowErrorHUD:(BOOL)isShowErrorHUD success:(successBlock)success;

/**
 post请求,需要签名

 @param url 请求地址
 @param parm 请求参数
 @param modelClass 请求返回的模型类型
 @param isCache 是否需要缓存s
 @param isShowLoadHUD 是否显示加载HUD
 @param isShowErrorHUD 是否显示错误HUD
 @param success 成功的回调
 */
-(void)post:(NSString *)url parm:(NSDictionary *)parm modelClass:(Class)modelClass isCache:(BOOL)isCache isShowLoadHUD:(BOOL)isShowLoadHUD isShowErrorHUD:(BOOL)isShowErrorHUD success:(successBlock)success;


@end

NS_ASSUME_NONNULL_END
