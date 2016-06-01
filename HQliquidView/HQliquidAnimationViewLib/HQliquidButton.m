//
//  HQliquidButton.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "HQliquidButton.h"
#import "HQliquidAnimationView.h"


#import "UILabel+ContentSize.h"

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define LAST_WINDOW [[UIApplication sharedApplication].windows lastObject]

#define kLableX self.frame.origin.x
#define kLableY self.frame.origin.y

@interface HQliquidButton()

@property (nonatomic, strong) UILabel *badgeLabel; //用于展示数字

@property (nonatomic, strong) HQliquidAnimationView *liquidAnimationView; //用于展示数字

@end

@implementation HQliquidButton

#pragma mark - initMethod
-(instancetype)initWithLocationCenter:(CGPoint)center bagdeNumber:(int)badgeNumber
{
    self = [super init];
    if (self) {
        
        self.center = center;
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        
        _bagdeNumber = badgeNumber;
       
        self.frame = CGRectMake(kLableX, kLableY, 30, 30);
        [self addSubview:self.badgeLabel];
        [self updateBagdeNumber:badgeNumber];

        //添加手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}
-(void)setBagdeLableWidth:(CGFloat)bagdeLableWidth{
    _bagdeLableWidth = bagdeLableWidth;
    
    [self updateBagdeNumber:_bagdeNumber];
}
#pragma mark - private
-(void)updateBagdeNumber:(int)bagdeNumber
{
    _bagdeNumber = bagdeNumber;
    if (!self.bagdeLableWidth) {
        _bagdeLableWidth = 20;
    }
    if (bagdeNumber < 10) {
        NSLog(@"%lf",kLableY);
        self.frame = CGRectMake(kLableX, kLableY, _bagdeLableWidth, _bagdeLableWidth);
        self.badgeLabel.center = CGPointMake(self.bounds.size.width*0.51, self.bounds.size.height*0.48);
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",bagdeNumber];
    }else if (bagdeNumber < 100) {
    
        self.frame = CGRectMake(kLableX-2, kLableY, _bagdeLableWidth+5, _bagdeLableWidth);
        self.badgeLabel.center = CGPointMake(self.bounds.size.width*0.51, self.bounds.size.height*0.48);
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",bagdeNumber];
    }else{
        
        self.frame = CGRectMake(kLableX-4, kLableY, _bagdeLableWidth+10, _bagdeLableWidth);
        self.badgeLabel.center = CGPointMake(self.bounds.size.width*0.51, self.bounds.size.height*0.48);
        self.badgeLabel.text = @"99+";
    }
    self.layer.cornerRadius = self.bounds.size.height*0.5;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint touchCenter = point;
    CGPoint viewCenter = self.center;
    CGRect viewRect = self.frame;
    
    BOOL flag =  CGRectContainsPoint(viewRect, touchCenter);
    CGFloat squlitValue = sqrtf(fabs(touchCenter.x)*fabs(touchCenter.x)+fabs(touchCenter.y)*fabs(touchCenter.y));
    if (squlitValue < 30) {
        flag = YES;
    }
    
//    BOOL flag = CGPointEqualToPoint(touchCenter, viewCenter);
    NSLog(@"%d   %lf  %lf",flag,squlitValue,viewRect.size.width);
    return flag;
}
#pragma mark - gesture
-(void)gestureAction:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPoint = [pan locationInView:LAST_WINDOW];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.hidden = YES;
//            NSLog(@"UIGestureRecognizerStateBegan");
            [[[UIApplication sharedApplication].windows lastObject] addSubview:self.liquidAnimationView];
            CGPoint originCenter = [self convertPoint:CGPointMake(10, 10) toView:(UIWindow *)LAST_WINDOW];
            self.liquidAnimationView.oringinCenter = originCenter;
            self.liquidAnimationView.radius = self.bounds.size.height*0.5;
            self.liquidAnimationView.badgeNumber = self.bagdeNumber;
            self.liquidAnimationView.maxWidth = self.bounds.size.width;
            self.liquidAnimationView.maxDistance = self.maxDistance;
            [self.liquidAnimationView clearViewState];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.liquidAnimationView.currentMovingPoint = currentPoint;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.hidden = NO;
            if (self.dragLiquidBlock) {
                HQliquidButton *btn = [[HQliquidButton alloc]init];
                
                    self.dragLiquidBlock(btn);
            
            }
//            NSLog(@"UIGestureRecognizerStateEnded");
            [self.liquidAnimationView removeFromSuperview];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            self.hidden = NO;
//            NSLog(@"UIGestureRecognizerStateEnded");
            [self.liquidAnimationView removeFromSuperview];
            
        }
            break;

            
        default:
            break;
    }
}

#pragma mark - getter & setter
-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] initWithFrame:self.bounds];

        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        [_badgeLabel setTextAlignment:NSTextAlignmentCenter];
        _badgeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _badgeLabel;
}

-(HQliquidAnimationView *)liquidAnimationView
{
    if (!_liquidAnimationView) {
        _liquidAnimationView = [[HQliquidAnimationView alloc] initWithFrame:KEY_WINDOW.bounds];
        _liquidAnimationView.backgroundColor = [UIColor clearColor];
    }
    return _liquidAnimationView;
}

@end
