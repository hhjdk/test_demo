//
//  CirleProgeressView.h
//  Sdx
//
//  Created by sdx on 2017/12/23.
//  Copyright © 2017年 sdx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAnimationDuration 1.0f

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define homeRingBegincolor UIColorFromRGB(0x06c1ae)  // 首页进度条渐变开始
#define homeRingEndcolor UIColorFromRGB(0x349ec7)  // 首页进度条渐变结束
// 随机颜色
#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]

//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
typedef NS_ENUM(NSInteger,CirleProgressType_)
{
    CirleProgressType_SolidLine = 0 ,   /// 实线
    CirleProgressType_DottedLine = 1,   /// 虚线
    CirleProgressType_DottedLine7Round = 2, // 虚线七分圆
    CirleProgressType_SolidLine7Round = 3, // 实线七分圆
};

@interface CirleProgeressView : UIView

/**
 *  进度值0-1.0之间
 */
@property (nonatomic,assign)CGFloat progressValue;

/**
 *  边宽
 */
@property(nonatomic,assign) CGFloat progressStrokeWidth;

/**
 *  进度条颜色
 */
@property(nonatomic,strong)UIColor *progressColor;

/**
 *  进度条轨道颜色
 */
@property(nonatomic,strong)UIColor *progressTrackColor;
/**
 *  进度条渐变开始颜色
 */
@property(nonatomic,strong)UIColor *progressBeginColor;
/**
 *  进度条渐变结束颜色
 */
@property(nonatomic,strong)UIColor *progressEndColor;

/**
  当前线类型  画的圆环是虚线还是实线的 默认实线
 */
@property (nonatomic,assign) CirleProgressType_ curCirleLine;


- (instancetype)initWithFrame:(CGRect)frame LineType:(CirleProgressType_)lineType;

- (instancetype)initWithFrame:(CGRect)frame LineType:(CirleProgressType_)lineType BeginColor:(UIColor*)beginColor EndColor:(UIColor *)endColor;


/**
 设置背景圆环的宽度，和进度圆环的宽度

 @param progressStrokeWidth 进度圆环宽度
 @param backWidth 背景圆环的宽度
 */
- (void)setProgressStrokeWidth:(CGFloat)progressStrokeWidth backstrokWidth:(CGFloat)backWidth;

- (void)stroke;

@end
