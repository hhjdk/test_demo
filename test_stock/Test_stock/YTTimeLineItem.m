//
//  YTTimeLineItem.m
//  Test_stock
//
//  Created by sdx on 2017/12/26.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import "YTTimeLineItem.h"

@implementation YTTimeLineItem


- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.pre_close_px           = dict[@"pre_close_px"];
        self.last_px          = dict[@"last_px"];
        self.curr_time            = dict[@"curr_time"];

    }
    return self;
    
}

+(id)newsWithDict:(NSDictionary *)dict {
    
    return  [[self alloc] initWithDict:dict];
    
}
@end
