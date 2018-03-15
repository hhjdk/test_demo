//
//  CirleProgeressView.m
//  Sdx
//
//  Created by sdx on 2017/12/23.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import "CirleProgeressView.h"

@interface CirleProgeressView ()
{
    
    CAShapeLayer *backGroundLayer; //背景图层
    CAShapeLayer *frontFillLayer;      //用来填充的图层
    UIBezierPath *backGroundBezierPath; //背景贝赛尔曲线
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    CAGradientLayer *gradientLayer; //渐变背景图层
    
    
}
@property (nonatomic) CAShapeLayer *bgCircleLayer;
@property (nonatomic) CGPoint curPoint;

@end

@implementation CirleProgeressView

@synthesize progressColor = _progressColor;
@synthesize progressTrackColor = _progressTrackColor;
@synthesize progressValue = _progressValue;
@synthesize progressStrokeWidth = _progressStrokeWidth;


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUp];
        
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame LineType:(CirleProgressType_)lineType;
{
    if (self = [super initWithFrame:frame])
    {
        self.curCirleLine = lineType;
        [self setUp];
        
    }
    return self;
    
}
- (instancetype)initWithFrame:(CGRect)frame LineType:(CirleProgressType_)lineType BeginColor:(UIColor*)beginColor EndColor:(UIColor *)endColor;
{
    if (self = [super initWithFrame:frame])
    {
        self.curCirleLine = lineType;
        self.progressBeginColor = beginColor;
        self.progressEndColor = endColor;
        self.curPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self setUp];
        NSLog(@"  x==== %f    y===== %f",self.center.x,self.center.y);
        
    }
    return self;
}


/**
 *  初始化创建图层
 */
- (void)setUp
{
    //创建背景图层
    backGroundLayer = [CAShapeLayer layer];
    backGroundLayer.fillColor = nil;
    backGroundLayer.frame = self.bounds;
    backGroundLayer.lineCap = kCALineCapRound;
    backGroundLayer.lineJoin = kCALineJoinRound;
    
    
    //创建填充图层
    frontFillLayer = [CAShapeLayer layer];
    frontFillLayer.fillColor = nil;
    frontFillLayer.frame = self.bounds;
    frontFillLayer.lineCap = kCALineCapRound; //线终点
    frontFillLayer.lineJoin = kCALineJoinRound; // 线拐角
    
     // 如果是虚线
    if (self.curCirleLine == CirleProgressType_DottedLine7Round ||  self.curCirleLine == CirleProgressType_DottedLine) {
        backGroundLayer.lineDashPattern  = @[@2,@6];  ///
        frontFillLayer.lineDashPattern  = @[@2,@6];  ///
//        frontFillLayer.lineCap = kCALineJoinBevel;
        backGroundLayer.lineCap = kCALineJoinMiter;
        frontFillLayer.lineCap = kCALineJoinMiter;
        [self.layer addSublayer:backGroundLayer];
        [self.layer addSublayer:frontFillLayer];
        
    }
    else
    {
        [self.layer addSublayer:backGroundLayer];
        //    [self.layer addSublayer:frontFillLayer];// 不用渐变

        //
        if (self.curCirleLine == CirleProgressType_SolidLine) {
            [self drawGradientLayer]; // 渐变
            gradientLayer.mask = frontFillLayer;
            [self.layer insertSublayer:backGroundLayer atIndex:0];
        }
        else if (self.curCirleLine == CirleProgressType_SolidLine7Round)
        {
            [self drawGradientLayer]; // 渐变
            gradientLayer.mask = frontFillLayer;
            [self.layer insertSublayer:backGroundLayer atIndex:0];
//            [self.layer insertSublayer:backGroundLayer atIndex:0];
//            [self.layer addSublayer:frontFillLayer];// 不用渐变
        }


    }
}


//设置进度颜色
- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    frontFillLayer.strokeColor = progressColor.CGColor;
}

- (UIColor *)progressColor
{
    return _progressColor;
}


/// 设置背景颜色
- (void)setProgressTrackColor:(UIColor *)progressTrackColor
{
    _progressTrackColor = progressTrackColor;
    backGroundLayer.strokeColor = progressTrackColor.CGColor;
    // 判断是七分圆还是十分圆
    if (self.curCirleLine == CirleProgressType_DottedLine7Round || self.curCirleLine == CirleProgressType_SolidLine7Round) {
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle:M_PI_4* 3 endAngle:M_PI_4 clockwise:YES];
    }
    else
    {
        backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle: - M_PI_2 endAngle: M_PI_2 * 3 clockwise:YES]; // 背景和进度开始要保持一致
       // backGroundBezierPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle:M_PI_4* 3 endAngle:M_PI*2 clockwise:YES];
    }
    
    

    backGroundLayer.path = backGroundBezierPath.CGPath;
}

- (UIColor *)progressTrackColor
{
    return _progressTrackColor;
}


/*****
 设置圆弧进度百分比
 ArcCenter: 原点
 radius: 半径
 startAngle: 开始角度
 endAngle: 结束角度
 clockwise: 是否顺时针方向 */
- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    // 判断是七分圆还是十分圆
    if (self.curCirleLine == CirleProgressType_DottedLine7Round || self.curCirleLine == CirleProgressType_SolidLine7Round)
    {
        frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle: M_PI_4 * 3 endAngle:(3*M_PI_2)*progressValue + M_PI_4 * 3 clockwise:YES];

    }
    else
    {

         frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:self.curPoint radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle: - M_PI_2 endAngle:(2*M_PI)*progressValue - M_PI_2 clockwise:YES];
    }
    frontFillLayer.path = frontFillBezierPath.CGPath;
    

}

- (CGFloat)progressValue
{
    return _progressValue;
}


//// 设置背景宽度和进度宽度
- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth backstrokWidth:(CGFloat)backWidth
{
    _progressStrokeWidth = progressStrokeWidth;
    frontFillLayer.lineWidth = progressStrokeWidth;
    backGroundLayer.lineWidth = backWidth;
}

- (CGFloat)progressStrokeWidth
{
    return _progressStrokeWidth;
}

/// 动画效果
- (void)stroke
{
    //画图动画
    self.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration  = kAnimationDuration;
    animation.fromValue = @0.0f;
    animation.toValue   = @1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = YES;
    [frontFillLayer addAnimation:animation forKey:@"circleAnimation"];
    
}
////// 绘制渐变图层
-(void)drawGradientLayer{
    
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)self.progressBeginColor.CGColor,(id)self.progressEndColor.CGColor];
    //    gradientLayer.locations = @[@0.0, @0.2, @0.5];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //    [self.contentView.layer addSublayer:gradientLayer];
//    [frontFillLayer insertSublayer:gradientLayer above:0];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    
}


//- (void)drawRect:(CGRect)rect {
//    
//    
////    UIColor *color = [UIColor redColor];
////    [color set];
////
////    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(CGRectGetWidth(self.bounds)-self.progressStrokeWidth)/2.f startAngle:0 endAngle:3.14* 1.5 clockwise:YES];
////
////    path.lineWidth = 5.0;
////    path.lineCapStyle = kCGLineCapRound;
////    path.lineJoinStyle = kCGLineJoinRound;
////
////    [path stroke];
//}
- (void)dealloc
{
    [self.layer removeAllAnimations];
}
@end
