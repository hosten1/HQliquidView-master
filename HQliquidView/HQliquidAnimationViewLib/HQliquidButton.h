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

@property (nonatomic, assign, readonly) int bagdeNumber;
@property (nonatomic, copy) dragLiquidViewDidStopReturnBlock dragLiquidBlock;
@property (nonatomic, assign) CGFloat bagdeLableWidth;

-(instancetype)initWithLocationCenter:(CGPoint)center bagdeNumber:(int)badgeNumber;

-(void)updateBagdeNumber:(int)bagdeNumber;

@end
