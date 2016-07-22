//
//  HQliquidButton.h
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQliquidButton;

typedef void(^dragLiquidViewDidStopReturnBlock)(HQliquidButton *liquid);

@interface HQliquidButton : UIView

@property (nonatomic, assign) NSInteger bagdeNumber;
@property (nonatomic, copy) dragLiquidViewDidStopReturnBlock dragLiquidBlock;
/**
 *  设置小红点最大触摸可识别范围(太大影响其他触摸事件) 默认20
 */
@property (assign,nonatomic) CGFloat maxTouchDistance;
/**
 *  设置高度 默认20
 */
@property (nonatomic, assign) CGFloat bagdeLableWidth;
/**
 *  设置最大连接长度，当起始点与当前点的距离大于maxDistance后,那么就进去分离状态 默认100
 */
@property (nonatomic, assign) CGFloat maxDistance;

-(instancetype)initWithLocationCenter:(CGPoint)center;
/**
 *  跟新的数值的时候调用
 *
 *  @param bagdeNumber 数值
 */
-(void)updateBagdeNumber:(NSInteger)bagdeNumber;
/** 按钮消失的动画图片组 */
@property (nonatomic, strong) NSMutableArray *images;
@end
