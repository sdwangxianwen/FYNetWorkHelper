//
//  NetModel.h
//  FYNetWorkHelper
//
//  Created by wang on 2018/12/14.
//  Copyright © 2018 wang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetModel : NSObject
@property(nonatomic,assign) NSInteger code;
@property(nonatomic,copy) NSString *message;
@end

@class comics;
@interface data : NetModel
@property (nonatomic, strong) NSArray<comics *> * comics;
@property (nonatomic, assign) long since;
@property (nonatomic, assign) long timestamp;
@end


//@class topic;

@interface comics : NSObject

@property (nonatomic, assign) BOOL can_view;
@property (nonatomic, assign) long comic_type;
@property (nonatomic, assign) long comments_count;
@property (nonatomic, copy) NSString * cover_image_url;
@property (nonatomic, assign) long created_at;
@property (nonatomic, assign) long id;
@property (nonatomic, assign) long info_type;
@property (nonatomic, assign) BOOL is_free;
@property (nonatomic, assign) BOOL is_liked;
@property (nonatomic, copy) NSString * label_color;
@property (nonatomic, copy) NSString * label_text;
@property (nonatomic, copy) NSString * label_text_color;
@property (nonatomic, assign) long likes_count;
@property (nonatomic, assign) long push_flag;
@property (nonatomic, assign) long selling_kk_currency;
@property (nonatomic, assign) long serial_no;
@property (nonatomic, assign) long shared_count;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, assign) long storyboard_cnt;
@property (nonatomic, copy) NSString * title;
//@property (nonatomic, strong) topic * topic;
@property (nonatomic, assign) long updated_at;
@property (nonatomic, assign) long updated_count;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) long zoomable;

@end
