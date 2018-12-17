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

@implementation netTool
+(instancetype)share {
    static dispatch_once_t onceToken;
    static netTool *tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    
    });
    return tool;
}

-(void)getData:(NSString *)url parm:(NSDictionary *)parm modelClass:(Class)modelClass isCache:(BOOL)isCache isShowLoadHUD:(BOOL)isShowLoadHUD isShowErrorHUD:(BOOL)isShowErrorHUD success:(successBlock)success {
    if (isShowLoadHUD) {
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    [FYNetworkHelper setRequestTimeoutInterval:0.5];
    [FYNetworkHelper GET:url parameters:parm isCache:isCache success:^(id responseObject) {
        if (isShowLoadHUD) {
            [SVProgressHUD dismiss];
        }
        NetModel *baseModel = [NetModel yy_modelWithJSON:responseObject];
        NSLog(@"%@",baseModel.message);
        if (baseModel.code == 200) {
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


@end
