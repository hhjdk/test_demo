//
//  YTTimeLineItem.h
//  Test_stock
//
//  Created by sdx on 2017/12/26.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTTimeLineItem : NSObject


@property (nonatomic,copy) NSString *pre_close_px;
@property (nonatomic,copy) NSString *last_px;
@property (nonatomic,copy) NSString *curr_time;
//@property (nonatomic,assign) float pre_close_px;
//@property (nonatomic,assign) float pre_close_px;

//自定义构造方法
-(id) initWithDict:(NSDictionary *)dict;
//类方法（规范）
+(id) newsWithDict:(NSDictionary *)dict;

@end
