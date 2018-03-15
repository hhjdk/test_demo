//
//  YTTimeLineView.h
//  Test_stock
//
//  Created by sdx on 2017/12/26.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTimeLineItem;
@interface YTTimeLineView : UIView

//@property (nonatomic ,strong) NSMutableArray *dataArrM;

/**分时数据列表*/
@property (nonatomic, strong)NSMutableArray<YTTimeLineItem*> *dataArrM;
@end

