//
//  ViewController.m
//  Test_gradientcircle
//
//  Created by sdx on 2018/3/13.
//  Copyright © 2018年 sdx. All rights reserved.
//

#import "ViewController.h"
#import "CirleProgeressView.h"

@interface ViewController ()
{
    CirleProgeressView *solidprogressView;
    CirleProgeressView *dottedprogressView;
    CirleProgeressView *solid7progressView;
    CirleProgeressView *dotted7progressView;
}

@end

@implementation ViewController
/***
 CirleProgressType_SolidLine = 0 ,   /// 实线
 CirleProgressType_DottedLine = 1,   /// 虚线
 CirleProgressType_DottedLine7Round = 2, // 虚线七分圆
 CirleProgressType_SolidLine7Round = 3, // 实线七分圆
 */
- (IBAction)btnClick:(id)sender {
    UIButton * btn = (UIButton*)sender;
    if (btn.tag == CirleProgressType_SolidLine + 1)
    {
        [self solidLine];
    }
    else if (btn.tag == CirleProgressType_DottedLine + 1)
    {
        [self dottedLine];
    }
    else if (btn.tag == CirleProgressType_DottedLine7Round + 1)
    {
        [self dottedLineRound7];
    }
    else if (btn.tag == CirleProgressType_SolidLine7Round + 1)
    {
        [self solidLineRound7];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma 实线渐变圆环
- (void)solidLine
{
    solidprogressView = [[CirleProgeressView alloc]initWithFrame:CGRectMake(50,50, 90, 90) LineType:(CirleProgressType_SolidLine) BeginColor:homeRingBegincolor EndColor:homeRingEndcolor];
    //solidprogressView.backgroundColor = [UIColor yellowColor];
    solidprogressView.progressColor = homeRingBegincolor;
    [solidprogressView setProgressStrokeWidth:15 backstrokWidth:15];
    solidprogressView.progressTrackColor = [UIColor grayColor];
    [self.view addSubview:solidprogressView];
    solidprogressView.progressValue = 0.7;
    [solidprogressView stroke];/// 开始圆环动画
}

#pragma 虚线圆环
- (void)dottedLine
{
    dottedprogressView = [[CirleProgeressView alloc]initWithFrame:CGRectMake(50,150, 90, 90) LineType:(CirleProgressType_DottedLine) BeginColor:homeRingBegincolor EndColor:homeRingEndcolor];
    //dottedprogressView.backgroundColor = [UIColor yellowColor];
    dottedprogressView.progressColor = homeRingBegincolor;
    [dottedprogressView setProgressStrokeWidth:15 backstrokWidth:15];
    dottedprogressView.progressTrackColor = [UIColor grayColor];
    [self.view addSubview:dottedprogressView];
    dottedprogressView.progressValue = 0.7;
    [dottedprogressView stroke];/// 开始圆环动画
}
#pragma 虚线七分圆环
- (void)dottedLineRound7
{
    solid7progressView = [[CirleProgeressView alloc]initWithFrame:CGRectMake(50,250, 90, 90) LineType:(CirleProgressType_DottedLine7Round) BeginColor:homeRingBegincolor EndColor:homeRingEndcolor];
    //solid7progressView.backgroundColor = [UIColor blueColor];
    solid7progressView.progressColor = homeRingBegincolor;
    [solid7progressView setProgressStrokeWidth:15 backstrokWidth:15];
    solid7progressView.progressTrackColor = [UIColor grayColor];
    [self.view addSubview:solid7progressView];
    solid7progressView.progressValue = 0.7;
    [solid7progressView stroke];/// 开始圆环动画
}


#pragma 实线七分圆环
- (void)solidLineRound7
{
    dotted7progressView = [[CirleProgeressView alloc]initWithFrame:CGRectMake(50,350, 90, 90) LineType:(CirleProgressType_SolidLine7Round) BeginColor:homeRingBegincolor EndColor:homeRingEndcolor];
    //dotted7progressView.backgroundColor = [UIColor redColor];
    dotted7progressView.progressColor = homeRingBegincolor;
    [dotted7progressView setProgressStrokeWidth:15 backstrokWidth:15];
    dotted7progressView.progressTrackColor = [UIColor grayColor];
    [self.view addSubview:dotted7progressView];
    dotted7progressView.progressValue = 0.7;
    [dotted7progressView stroke];/// 开始圆环动画
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
