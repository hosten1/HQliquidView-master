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

#define kLableX floor(self.frame.origin.x)
#define kLableY floor(self.frame.origin.y)

@interface HQliquidButton()

@property (nonatomic, strong) UILabel *badgeLabel; //用于展示数字
@property (nonatomic, assign) CGPoint oldPoint; //用于存储最初的位置
@property (nonatomic, assign) CGRect oldBounds; //用于存储最初的位置
@property (nonatomic, assign) CGPoint moveToPoint; //用于存储移动后的位置
@property(nonatomic,assign)NSInteger isFirstInitNumber;
@property(nonatomic,assign)BOOL oneCallBackBlick;
@end

@implementation HQliquidButton
#pragma mark - 懒加载
- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_images addObject:image];
        }
    }
    
    return _images;
}

#pragma mark - initMethod

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutWithLocationCenter:self.center];
}

-(instancetype)initWithLocationCenter:(CGPoint)center
{
    self = [super init];
    if (self) {
        [self layoutWithLocationCenter:center];
    }
    return self;
}

- (void)layoutWithLocationCenter:(CGPoint)center
{
    self.center = CGPointMake(ceil(center.x), ceil(center.y));
    _oldPoint = self.center;
    self.oldBounds = CGRectMake(kLableX, kLableY,0 , 0);
    self.layer.cornerRadius = center.x == center.y?center.x*0.5:center.y*0.5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    [self insertSubview:self.badgeLabel aboveSubview:self];
    _bagdeNumber=0;
    _isFirstInitNumber = 0;
    _oneCallBackBlick = false;
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:pan];
}

-(void)setBagdeLableWidth:(CGFloat)bagdeLableWidth{
    _bagdeLableWidth = bagdeLableWidth;
    _isFirstInitNumber = 0;
    [self updateBagdeNumber:_bagdeNumber];
}
-(void)setBagdeNumber:(NSInteger)bagdeNumber{
     _bagdeNumber = 0;
     _bagdeNumber = bagdeNumber;
    if (_bagdeNumber != 0) {
        _isFirstInitNumber = YES;
        [self updateBagdeNumber:bagdeNumber];
    }
}
#pragma mark - private
-(void)updateBagdeNumber:(NSInteger)bagdeNumber
{
    if (!self.bagdeLableWidth) {
        _bagdeLableWidth = 20;
    }
    CGFloat width =ceil(_bagdeLableWidth);
    if (bagdeNumber < 10) {
//        if (_isFirstInitNumber != 1) {
            self.frame = CGRectMake( self.oldBounds.origin.x+3, kLableY,width , width);
            self.badgeLabel.center = CGPointMake(ceil(self.bounds.size.width*0.5),ceil( self.bounds.size.height*0.42));
//        }

            self.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)bagdeNumber];
            _isFirstInitNumber = 1;
    }else if (bagdeNumber < 100 ) {
//        if (_isFirstInitNumber != 100) {
            self.frame = CGRectMake(self.oldBounds.origin.x-5 , kLableY, width+7, width);
            self.badgeLabel.center = CGPointMake(ceil(self.bounds.size.width*0.47), ceil(self.bounds.size.height*0.45));
//        }
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)bagdeNumber];
        _isFirstInitNumber = 100;
    }else{
//        if (_isFirstInitNumber != 10) {
            self.frame = CGRectMake(self.oldBounds.origin.x-10 , kLableY, width+12, width);
            self.badgeLabel.center = CGPointMake(ceil(self.bounds.size.width*0.51),ceil(self.bounds.size.height*0.45));
//        }
        
        self.badgeLabel.text = @"99+";
         _isFirstInitNumber = 10;
    }
//    NSLog(@">>>>>>>>>>>>>>>>>>>%lf,%lf",kLableX,kLableY);
    _badgeLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.layer.cornerRadius = self.bounds.size.height*0.5;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint touchCenter = point;
    CGRect viewRect = self.frame;
    
    BOOL flag =  CGRectContainsPoint(viewRect, touchCenter);
    CGFloat squlitValue = sqrtf(fabs(touchCenter.x)*fabs(touchCenter.x)+fabs(touchCenter.y)*fabs(touchCenter.y));
    if (!self.maxDistance || self.maxDistance == 0.0f) {
        _maxDistance = 20;
    }
    if (squlitValue < self.maxTouchDistance) {
        
        flag = YES;
    }
    
    return flag;
}
#pragma mark - gesture
-(void)gestureAction:(UIPanGestureRecognizer *)pan
{
    __weak HQliquidButton *weakSelf = self;
    CGPoint currentPoint = [pan locationInView:LAST_WINDOW];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.hidden = YES;
//            NSLog(@"UIGestureRecognizerStateBegan");
            [[[UIApplication sharedApplication].windows lastObject] addSubview:self.liquidAnimationView];
            CGPoint originCenter = [self convertPoint:CGPointMake(10, 10) toView:(UIWindow *)LAST_WINDOW];
            self.liquidAnimationView.oringinCenter = originCenter;
            self.liquidAnimationView.maxDistance = self.maxDistance;
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
            _moveToPoint = CGPointMake(currentPoint.x,currentPoint.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            
                CGFloat disX = self.liquidAnimationView.currentMovingPoint.x - self.liquidAnimationView.oringinCenter.x;
                CGFloat disY = self.liquidAnimationView.currentMovingPoint.y - self.liquidAnimationView.oringinCenter.y;
                
                self.transform = CGAffineTransformMakeTranslation(disX, disY); //x轴左右移动
                [UIView animateWithDuration:0.6 delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.transform = CGAffineTransformIdentity;
                    if (fabs(self.liquidAnimationView.currentDistance)  > self.maxDistance) {
                        self.liquidAnimationView.currentDistance = self.liquidAnimationView.currentDistance;
                        if (weakSelf.dragLiquidBlock ) {
                            weakSelf.hidden = YES;
                            weakSelf.dragLiquidBlock(weakSelf);
                            //只允许执行一次回调操作
                            weakSelf.oneCallBackBlick=true;
//                            [self  startDestroyAnimations];
                        }

                    }else{

                       self.hidden = NO;
                    }
                    //            NSLog(@"UIGestureRecognizerStateEnded");
                    [self.liquidAnimationView removeFromSuperview];
                    
                } completion:^(BOOL finished) {
//                    [self viewScaleAnimation];
                }];
                
                
                

           
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            CGFloat disX = self.liquidAnimationView.currentMovingPoint.x - self.liquidAnimationView.oringinCenter.x;
            CGFloat disY = self.liquidAnimationView.currentMovingPoint.y - self.liquidAnimationView.oringinCenter.y;
            //                NSLog(@"ddddddd>>>>>>>>>>%lf,%lf",disX,disY);
            self.transform = CGAffineTransformMakeTranslation(disX, disY); //x轴左右移动
            [UIView animateWithDuration:0.6 delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.hidden = NO;
                self.transform = CGAffineTransformIdentity;
                [self.liquidAnimationView removeFromSuperview];
            }completion:^(BOOL finished) {
                
            }];
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
    
        _badgeLabel = [[UILabel alloc] init];

        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:12];
        [_badgeLabel setTextAlignment:NSTextAlignmentCenter];
        _badgeLabel.adjustsFontSizeToFitWidth = YES;
       
    }
    return _badgeLabel;
}
#pragma mark - button消失动画
- (void)startDestroyAnimations
{
    UIImageView *ainmImageView = [[UIImageView alloc]init];
    ainmImageView.bounds = CGRectMake(0, 0, 100, 100);
    ainmImageView.center = self.liquidAnimationView.currentMovingPoint;
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 2;
    ainmImageView.animationDuration = 0.6;
    [ainmImageView startAnimating];
    
    [(UIWindow *)LAST_WINDOW addSubview:ainmImageView];
}
#pragma mark - 设置长按时候左右摇摆的动画
//view缩放
-(void)viewScaleAnimation
{
    
    self.transform = CGAffineTransformMakeScale(0.5, 0.5); //先缩小
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;//恢复原状
    } completion:^(BOOL finished) {
        
    }];
}

//view左右移动
-(void)viewTranslationAnimation
{
    self.transform = CGAffineTransformMakeTranslation(20, 0); //x轴左右移动
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self viewScaleAnimation];
    }];
    
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
