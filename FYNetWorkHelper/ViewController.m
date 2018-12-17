//
//  ViewController.m
//  FYNetWorkHelper
//
//  Created by wang on 2018/9/30.
//  Copyright © 2018 wang. All rights reserved.
//

#import "ViewController.h"
#import "FYNetTool/FYNetWorkHelper.h"
#import "netTool.h"
#import "NetModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary *dict = @{@"gender" :@(1),
                           @"new_device" :@(NO),
                           @"since":@(0)
                           };
    NSString *url = @"https://api.kkmh.com/v1/daily/comic_lists/0";
    [[netTool share] getData:url parm:dict modelClass:[data class] isCache:YES isShowLoadHUD:YES isShowErrorHUD:YES success:^(id response) {
        
    }];
}


@end
