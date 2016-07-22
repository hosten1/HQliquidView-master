//
//  HQliquidAnimationView.h
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HQliquidAnimationViewState) {
    HQliquidAnimationViewStateUnknown  = 0,   //未知状态
    HQliquidAnimationViewStateConnect  = 1,     //处于粘连状态
    HQliquidAnimationViewStateSeperated = 2,    //处于分离状态，当分离后，距离靠近之后，并不会再度粘连
};

typedef void(^dragLiquidViewDidDistaceBlock)(CGFloat distance);
@interface HQliquidAnimationView : UIView
@property (nonatomic, copy) dragLiquidViewDidDistaceBlock distanceLiquidBlock;
@property (assign,nonatomic) CGFloat maxTouchDistance;
@property (nonatomic, assign) NSInteger badgeNumber;

@property (nonatomic, assign) CGPoint oringinCenter;  //初始点
@property (nonatomic, assign) CGPoint currentMovingPoint;   //当前点

@property (nonatomic, assign) float maxDistance; //设置最大连接长度，当起始点与当前点的距离大于maxDistance后,那么就进去分离状态
@property (nonatomic, assign) float maxWidth;
@property (nonatomic, assign) float radius;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat currentDistance;
-(void)clearViewState;

@end
