//
//  ViewController.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/9/30.
//  Copyright © 2018 wang. All rights reserved.
//

#import "ViewController.h"
#import "FYNetTool/FYNetWorkHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = @{@"gender" :@(1),
                           @"new_device" :@(NO),
                           @"since":@(0)
                           };
    NSString *url = @"https://api.kkmh.com/v1/daily/comic_lists/0";
    [FYNetworkHelper GET:url parameters:dict isCache:YES success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error, id cacheReponse) {
        NSLog(@"%@",cacheReponse);
    }];
}


@end
