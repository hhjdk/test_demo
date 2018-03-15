//
//  ViewController.m
//  Test_stock
//
//  Created by sdx on 2017/12/26.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import "ViewController.h"
#import "YTTimeLineView.h"
#import "YTTimeLineItem.h"

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray<YTTimeLineItem*> * stockArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    YTTimeLineView * lineview = [[YTTimeLineView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width)];
    [self.view addSubview:lineview];
    
    self.stockArray = [[NSMutableArray alloc] init];
    
    //加载plist文件数据数组
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stock.plist" ofType:nil]];
    self.stockArray = [[NSMutableArray alloc] init];
    for (NSDictionary *arr in array) {
        [self.stockArray addObject:[YTTimeLineItem newsWithDict:arr]];
    }

    [lineview setDataArrM:self.stockArray];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
