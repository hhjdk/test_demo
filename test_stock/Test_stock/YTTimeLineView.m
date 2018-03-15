//
//  YTTimeLineView.m
//  Test_stock
//
//  Created by sdx on 2017/12/26.
//  Copyright © 2017年 sdx. All rights reserved.
//  www.github.com

#import "YTTimeLineView.h"
#import "YTTimeLineItem.h"


#define DPW self.frame.size.width
#define DPH self.frame.size.height

@interface YTTimeLineView ()
/**纵坐标最大值*/
@property (nonatomic, assign) double max;
/**纵坐标中间值*/
@property (nonatomic, assign) double mid;
/**纵坐标最小值*/
@property (nonatomic, assign) double min;
/**分时线路径*/
@property (nonatomic, strong) UIBezierPath *timeLinePath;
/**最新点坐标*/
@property (nonatomic, assign) CGPoint currentPoint;
/**是否显示背景*/
@property (nonatomic, assign) BOOL isNeedBackGroundColor;
/**心跳点*/
@property (nonatomic, strong) CALayer *heartLayer;
/**分时线*/
@property (nonatomic, strong) CAShapeLayer *timeLineLayer;
/**十字光标*/
@property (nonatomic, strong) CAShapeLayer *crossLayer;
/**十字光标时间轴文字*/
@property (nonatomic, strong) CATextLayer *crossTimeLayer;
/**十字光标价格轴文字*/
@property (nonatomic, strong) CATextLayer *crossPriceLayer;
@end

@implementation YTTimeLineView
#pragma mark - 入口
//alloc方法调用
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupGestureRecognize];
    }
    return self;
}
//load nib 调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupGestureRecognize];
    }
    return self;
}
#pragma mark - 懒加载
- (UIBezierPath *)timeLinePath {
    if (!_timeLinePath) {
        _timeLinePath = [[UIBezierPath alloc]init];
    }
    return _timeLinePath;
}
- (CALayer *)heartLayer {
    if (!_heartLayer) {
        _heartLayer = [CALayer layer];
        _heartLayer.backgroundColor = [UIColor blueColor].CGColor;
    }
    return _heartLayer;
}
- (CAShapeLayer *)timeLineLayer {
    if (!_timeLineLayer) {
        _timeLineLayer = [[CAShapeLayer alloc]init];
        _timeLineLayer.strokeColor = [UIColor redColor].CGColor;
        _timeLineLayer.lineWidth = 0.5f;
    }
    return _timeLineLayer;
}
- (CAShapeLayer *)crossLayer {
    if (!_crossLayer) {
        _crossLayer =[[CAShapeLayer alloc]init];
        _crossLayer.lineDashPattern = @[@1, @2];//画虚线
    }
    return _crossLayer;
}
- (CATextLayer *)crossPriceLayer {
    if (!_crossPriceLayer) {
        _crossPriceLayer = [[CATextLayer alloc]init];
    }
    return _crossPriceLayer;
}
- (CATextLayer *)crossTimeLayer {
    if (!_crossTimeLayer) {
        _crossTimeLayer = [[CATextLayer alloc]init];
    }
    return _crossTimeLayer;
}
#pragma mark - GestureRecognize
/**添加手势*/
- (void)setupGestureRecognize {
    UILongPressGestureRecognizer  *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}
/**长按*/
- (void)longPressAction:(UILongPressGestureRecognizer*)gesture {
    CGPoint tempPoint = [gesture locationInView:self];
    //越界控制
    if (tempPoint.x >= DPW) {
        tempPoint = CGPointMake(DPW, tempPoint.y);
    }
    if (tempPoint.x <= 0.0) {
        tempPoint = CGPointMake(0, tempPoint.y);
    }
    if (tempPoint.y >= DPH - 60) {
        tempPoint = CGPointMake(tempPoint.x, DPH-60);
    }
    if (tempPoint.y <= 0.0) {
        tempPoint = CGPointMake(tempPoint.x, 0);
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self drawCrossLineWithPoint:tempPoint];
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self drawCrossLineWithPoint:tempPoint];
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }
}
/**点击*/
- (void)tap:(UITapGestureRecognizer*) gesture {
    self.crossLayer.path = nil;
    [self.crossPriceLayer removeFromSuperlayer];
    [self.crossTimeLayer removeFromSuperlayer];
}
#pragma mark - 数据入口
- (void)setDataArrM:(NSMutableArray<YTTimeLineItem *> *)dataArrM {
    _dataArrM = dataArrM;
    //0.数据处理,拿到纵坐标数据
    [self preworkForData];
    //1.画框架
    [self drawFramework];
    //2.画文字
    //3.画分时线
    [self drawTimeLine];
    //4.画末尾的心跳点
    [self setupheartLayer];
}
#pragma mark - 画图方法

- (void)drawTimeLine  {
    if (self.isNeedBackGroundColor) {
        [self.timeLinePath addLineToPoint:CGPointMake(self.currentPoint.x , DPH - 60)];
        self.timeLineLayer.fillColor = [UIColor lightGrayColor].CGColor;
    }else {
        self.timeLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    self.timeLineLayer.path = self.timeLinePath.CGPath;
    [self.layer addSublayer:self.timeLineLayer];
    
}
/**画框架*/
- (void)drawFramework {
    UIBezierPath *path = [[UIBezierPath alloc]init];
    //三条横线
    CGFloat rowSpace = (DPH -60.0)/2.0;
    NSString *tempStr = @"";
    for (int i = 0; i < 3; i ++) {
        [path moveToPoint:CGPointMake(0,rowSpace*i)];
        [path addLineToPoint:CGPointMake(DPW, rowSpace*i)];
        if (0 == i) {
            tempStr = [NSString stringWithFormat:@"%.2f",self.max];
        }else if (1==i) {
            tempStr = [NSString stringWithFormat:@"%.2f",self.mid];
        }else if (2 == i) {
            tempStr = [NSString stringWithFormat:@"%.2f",self.min];
        }
        [self drawLabelAtRect:CGRectMake(-25, rowSpace*i-10, 25, 20) textStr:tempStr];
    }
    //4条竖线
    CGFloat colSpace = DPW / 4.0;
    for (int i = 0; i < 5; i ++) {
        [path moveToPoint:CGPointMake(colSpace*i,0)];
        [path addLineToPoint:CGPointMake(colSpace*i, DPH-60)];
        if (0 == i) {
            tempStr = @"9:30";
            [self drawLabelAtRect:CGRectMake(colSpace*i, DPH-60 ,30,20) textStr:tempStr];
            continue;
        }else if (1==i) {
            tempStr = @"10:30";
        }else if (2 == i) {
            tempStr = @"11:30/13:00";
            [self drawLabelAtRect:CGRectMake(colSpace*i-30, DPH-60 ,70,20) textStr:tempStr];
            continue;
        }else if (3==i) {
            tempStr = @"14:00";
        }else if (4 == i) {
            tempStr = @"15:00";
            [self drawLabelAtRect:CGRectMake(colSpace*i - 30, DPH-60 ,30,20) textStr:tempStr];
            continue;
        }
        [self drawLabelAtRect:CGRectMake(colSpace*i-15, DPH-60 ,35,20) textStr:tempStr];
    }
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.path = path.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}

/**画xy轴文字,直接创建一个CATextLayer*/
- (void)drawLabelAtRect:(CGRect)rect textStr:(NSString*)textStr {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = rect;
    [self.layer addSublayer:textLayer];
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:10];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    //choose some text
    //set layer text
    textLayer.string = textStr;
}
/**画文字十字光标文字,指定CATextLayer*/
- (void)drawCrossLabelWithTextLayer:(CATextLayer*)textLayer AtRect:(CGRect)rect textStr:(NSString*)textStr {
    textLayer.frame = rect;
    [self.layer addSublayer:textLayer];
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:10];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    //choose some text
    //set layer text
    textLayer.string = textStr;
}

/**画十字光标线*/
- (void)drawCrossLineWithPoint:(CGPoint)point {
    UIBezierPath * path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(point.x, 0)];
    [path addLineToPoint:CGPointMake(point.x, DPH - 60)];
    [path moveToPoint:CGPointMake(0, point.y)];
    [path addLineToPoint:CGPointMake(DPH, point.y)];
    self.crossLayer.strokeColor = [UIColor blueColor].CGColor;
    self.crossLayer.path = path.CGPath;
    [self.layer addSublayer: self.crossLayer];
    //画坐标点对于文字
    NSString *price =  [self pricWithPoint:point];
    NSString *time = [self timeWithPoint:point];
    [self drawCrossLabelWithTextLayer:self.crossTimeLayer AtRect:CGRectMake(point.x, DPH-60, 30, 20) textStr:time];
    [self drawCrossLabelWithTextLayer:self.crossPriceLayer AtRect:CGRectMake(0, point.y, 30, 20) textStr:price];
    
}
/**添加心跳效果*/
- (void)setupheartLayer {
    self.heartLayer.frame = CGRectMake(0, 0, 4, 4);
    self.heartLayer.position = self.currentPoint;
    self.heartLayer.cornerRadius = _heartLayer.frame.size.width*0.5;
    self.heartLayer.masksToBounds = YES;
    [self.layer addSublayer:self.heartLayer];
    [self heartAnimationWithLayer:self.heartLayer];
}
#pragma mark - Others
/**数据处理*/
- (void)preworkForData {
    //0 拿到纵坐标的3个点(max,mid,min),mid=昨日收盘价
    YTTimeLineItem *temp = self.dataArrM[0];
    self.mid = [temp.pre_close_px doubleValue];
    if ([temp.last_px doubleValue] -[temp.pre_close_px doubleValue] > 0) {
        self.max = [temp.last_px doubleValue];
        self.min = [temp.pre_close_px doubleValue] -([temp.last_px doubleValue] -[temp.pre_close_px doubleValue] );
    }else {
        self.min = [temp.last_px doubleValue];
        self.max =  [temp.pre_close_px doubleValue] + ([temp.pre_close_px doubleValue] -[temp.last_px doubleValue] );
    }
    for (int i = 0; i< self.dataArrM.count; i ++ ) {
        YTTimeLineItem *item = self.dataArrM[i];
        //获取纵坐标最大,最小,中间值
        if (fabs(item.last_px.doubleValue - self.mid) >(self.max - self.mid)) {
            self.max = self.mid +fabs(item.last_px.doubleValue - self.mid);
            self.min = self.mid - fabs(item.last_px.doubleValue - self.mid);
        }
        //画分时线
        CGFloat timeX = [self miniteTimeWithTimeStr:item.curr_time];
        CGFloat priceY = [self priceLabelLocationWithPrice:item.last_px.floatValue];
        if (i == 0) {
            if (self.isNeedBackGroundColor) {
                [self.timeLinePath moveToPoint:CGPointMake(0, DPH - 60)];
                [self.timeLinePath addLineToPoint:CGPointMake(timeX, priceY)];
            }else {
                [self.timeLinePath moveToPoint:CGPointMake(timeX, priceY)];
            }
        }
        if (i == self.dataArrM.count-1) {
            self.currentPoint = CGPointMake(timeX, priceY);
        }
        [self.timeLinePath addLineToPoint:CGPointMake(timeX,  priceY)];
    }
}
/**根据时间获取坐标点*/
-(CGFloat)miniteTimeWithTimeStr:(NSString*)timeStr {
    if (timeStr == nil || [timeStr isEqualToString:@""]) return 0.0;
    NSArray *temp = [timeStr componentsSeparatedByString:@":"];
    NSInteger minte = [temp[0] integerValue]*60 + [temp[1] integerValue];
    //每分钟代表的宽度
    CGFloat aveWidth = DPW/ 240.0;
    if (minte <= 11*60+30) {//上午
        return aveWidth*(minte - 9*60-30);
    }else {//下午
        return DPW *0.5 + aveWidth*(minte - 13*60);
    }
}

/**根据坐标点获取对应时间*/
-(NSString*)timeWithPoint:(CGPoint)point{
    NSString *str = @"";
    //单位距离代表的时间
    CGFloat aveWidth = 240.0/DPW;
    CGFloat totalTime = aveWidth * point.x + 9*60 + 30;//上午
    if (point.x >DPW *0.5) {
        totalTime = aveWidth * point.x + 11*60;//下午
    }
    int h = totalTime / 60;
    int m =  ((int)(totalTime + 0.5)) % 60;
    str = [NSString stringWithFormat:@"%d:%d",h,m];
    return str;
}
/**根据价格获取坐标位置*/
- (CGFloat)priceLabelLocationWithPrice:(CGFloat)price {
    CGFloat height = DPH - 60;
    CGFloat avrSpace = height/(self.max - self.min);
    return height - ((price - self.min)*avrSpace);
}
/**根据坐标位置获取价格*/
- (NSString*)pricWithPoint:(CGPoint)point {
    NSString *price = @"";
    //单位距离代表的价格
    CGFloat avePrice = (self.max - self.min)/(DPH - 60);
    //保留两位小数
    price = [NSString stringWithFormat:@"%.2f",(self.max - point.y*avePrice)+0.005];
    return price;
}
/**心跳动画*/
- (void)heartAnimationWithLayer:(CALayer*)layer {
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    group.duration = 0.5;
    group.repeatCount = HUGE;
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.toValue = @1.2;
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.toValue = @0.3f;
    group.animations = @[scaleAnim,alphaAnim];
    [layer addAnimation:group forKey:nil];
}

@end
