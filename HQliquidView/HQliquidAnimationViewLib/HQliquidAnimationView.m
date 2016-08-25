//
//  HQliquidAnimationView.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "HQliquidAnimationView.h"

#define kFromRadiusScaleCoefficient     0.06f
#define kToRadiusScaleCoefficient       0.1f

static inline CGFloat distanceBetweenPoints (CGPoint pointA, CGPoint pointB) {
    CGFloat deltaX = pointB.x - pointA.x;
    CGFloat deltaY = pointB.y - pointA.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
};

@interface HQliquidAnimationView()

@property (nonatomic, assign)CGFloat r1;
@property (nonatomic, assign)CGFloat r2;
@property (nonatomic, assign)CGFloat x1;
@property (nonatomic, assign)CGFloat y1;
@property (nonatomic, assign)CGFloat x2;
@property (nonatomic, assign)CGFloat y2;
@property (nonatomic, assign)CGFloat centerDistance;
@property (nonatomic, assign)CGFloat cosDigree;
@property (nonatomic, assign)CGFloat sinDigree;

@property (nonatomic, assign)CGPoint pointA; //A
@property (nonatomic, assign)CGPoint pointB; //B
@property (nonatomic, assign)CGPoint pointD; //D
@property (nonatomic, assign)CGPoint pointC; //C
@property (nonatomic, assign)CGPoint pointO; //O
 @property (nonatomic, assign)CGPoint pointP; //P


@property (nonatomic, assign) float fromRadius;
@property (nonatomic, assign) float toRadius;

@property (nonatomic, assign) float viscosity;

@property (nonatomic, assign) HQliquidAnimationViewState currentState;

@end

@implementation HQliquidAnimationView

#pragma mark - setter
-(void)setOringinCenter:(CGPoint)oringinCenter
{
    _oringinCenter = oringinCenter;
    _currentMovingPoint = oringinCenter;
    
    [self setNeedsDisplay];
}

-(void)setCurrentMovingPoint:(CGPoint)currentMovingPoint
{
    _currentMovingPoint = currentMovingPoint;
    
    self.currentDistance = distanceBetweenPoints(_oringinCenter, _currentMovingPoint);
    
    [self updateRadius];
    [self setNeedsDisplay];
}

-(void)setCurrentDistance:(CGFloat)currentDistance
{
    if (!self.maxDistance) {
        _maxDistance = 100.0f;
    }
    _currentDistance = currentDistance;
    if (_currentDistance > _maxDistance) {
        if (self.distanceLiquidBlock) {
            
            self.distanceLiquidBlock(_currentDistance);
            
        }

        _currentState = HQliquidAnimationViewStateSeperated;
    }
}

-(void)setRadius:(float)radius
{
    _radius = radius;
    if (!self.maxDistance) {
         _maxDistance = 100.0f;
    }
   
}

#pragma mark drawCode
- (void)drawRect:(CGRect)rect {
    if (_maxDistance < _currentDistance || _currentState == HQliquidAnimationViewStateSeperated) {//分离
        CGFloat marginRadius = self.maxWidth-2*self.radius;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
        CGContextAddArc(ctx, _currentMovingPoint.x, _currentMovingPoint.y, self.radius, M_PI_2,  -M_PI_2, YES);
        CGContextAddLineToPoint(ctx, _currentMovingPoint.x-marginRadius, _currentMovingPoint.y-self.radius);
        CGContextAddArc(ctx, _currentMovingPoint.x-marginRadius, _currentMovingPoint.y, self.radius, -M_PI_2,  M_PI_2, YES);
        CGContextFillPath(ctx);
        
        NSMutableParagraphStyle *paragraphMaking = [[NSMutableParagraphStyle alloc] init];
        paragraphMaking.alignment = NSTextAlignmentCenter;
        BOOL isOverNumber = self.badgeNumber>99?YES:NO;
        NSString *titleMaking = isOverNumber?[NSString stringWithFormat:@"%@",@"99+"]:[NSString stringWithFormat:@"%ld",(long)self.badgeNumber];
        NSDictionary *attributesMaking = @{
                                           NSParagraphStyleAttributeName:paragraphMaking,
                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                           };
        CGFloat x = self.badgeNumber>=10?(self.badgeNumber>99?_currentMovingPoint.x-self.radius*2.0:_currentMovingPoint.x-self.radius*1.7):_currentMovingPoint.x-self.radius*1.2;
        [titleMaking drawInRect:CGRectMake(x, _currentMovingPoint.y-7, isOverNumber?_maxWidth+5: _maxWidth, self.radius*2) withAttributes:attributesMaking];
        
    }else{//未分离
        
        UIBezierPath* path = [self bezierPathWithFromPoint:_oringinCenter toPoint:_currentMovingPoint fromRadius:_fromRadius+5  toRadius:_toRadius+10 scale:_viscosity];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
        CGContextAddPath(ctx, path.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
        NSMutableParagraphStyle *paragraphMaking = [[NSMutableParagraphStyle alloc] init];
        paragraphMaking.alignment = NSTextAlignmentCenter;
        BOOL isOverNumber = self.badgeNumber>99?YES:NO;
        NSString *titleMaking = isOverNumber?[NSString stringWithFormat:@"%@",@"99+"]:[NSString stringWithFormat:@"%ld",(long)self.badgeNumber];
        NSDictionary *attributesMaking = @{
                                           NSParagraphStyleAttributeName:paragraphMaking,
                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                           };
        CGFloat x = self.badgeNumber>=10?(self.badgeNumber>99?_currentMovingPoint.x-self.radius:_currentMovingPoint.x-self.radius):_currentMovingPoint.x-self.radius*1.2;

        [titleMaking drawInRect:CGRectMake(x, _currentMovingPoint.y-7,isOverNumber?_maxWidth+5: _maxWidth, self.radius*2) withAttributes:attributesMaking];
 
    }
}
#pragma mark - public
-(void)clearViewState
{
    _currentState = HQliquidAnimationViewStateConnect;
}

#pragma mark - private
- (void)updateRadius {
    CGFloat r = distanceBetweenPoints(_oringinCenter, _currentMovingPoint);
    _fromRadius = self.radius*0.5-kFromRadiusScaleCoefficient*r;
    _toRadius = self.radius*kToRadiusScaleCoefficient;
    _viscosity = 1.0-r/_maxDistance;
    
    [self setNeedsDisplay];
}
#pragma mark - 俩个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB
{
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    
    return dist;
}
- (UIBezierPath* )bezierPathWithFromPoint:(CGPoint)fromPoint
                                  toPoint:(CGPoint)toPoint
                               fromRadius:(CGFloat)fromRadius
                                 toRadius:(CGFloat)toRadius scale:(CGFloat)scale{
    UIBezierPath* path = [UIBezierPath bezierPath] ;
    
   CGFloat x1 = fromPoint.x;
   CGFloat y1 = fromPoint.y;
   CGFloat x2 = toPoint.x;
   CGFloat y2 = toPoint.y;
   CGFloat centerDistance = [self pointToPoitnDistanceWithPoint:fromPoint potintB:toPoint];
    
    CGFloat cosDigree = 0;
    CGFloat sinDigree = 0;
    if (centerDistance == 0) {
       self. cosDigree = 1;
       self. sinDigree = 0;
    }else{
       self.cosDigree = (y2-y1)/centerDistance;
       self.sinDigree = (x2-x1)/centerDistance;
    }
    cosDigree = self.cosDigree;
    sinDigree = self.sinDigree;
    
   CGFloat  r1 = fromRadius*0.7;
   CGFloat  r2 = toRadius;
   CGPoint pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
   CGPoint pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree);  // B
   CGPoint pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree);  // D
   CGPoint pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);  // C
    //判断四个象限分别处理
    CGFloat disX = self.currentMovingPoint.x - self.oringinCenter.x;

    CGFloat disY = self.currentMovingPoint.y - self.oringinCenter.y;

    CGPoint  pointO = CGPointMake(pointA.x+5 + (centerDistance / 2)*sinDigree, pointA.y+5 + (centerDistance / 2)*cosDigree);
    CGPoint  pointP = CGPointMake(pointB.x-5 + (centerDistance / 2)*sinDigree, pointB.y-5 + (centerDistance / 2)*cosDigree);
    if (disX >=0 && disY<0) {
//        NSLog(@"在第一象限");
        pointO = CGPointMake(pointA.x-5 + (centerDistance / 2)*sinDigree, pointA.y-5 + (centerDistance / 2)*cosDigree);
        pointP = CGPointMake(pointB.x+5 + (centerDistance / 2)*sinDigree, pointB.y+5 + (centerDistance / 2)*cosDigree);

    }else if (disX>=0 && disY>0) {
//        NSLog(@"在第四象限");
        pointO = CGPointMake(pointA.x+5 + (centerDistance / 2)*sinDigree, pointA.y-5 + (centerDistance / 2)*cosDigree);
        pointP = CGPointMake(pointB.x-5 + (centerDistance / 2)*sinDigree, pointB.y+5 + (centerDistance / 2)*cosDigree);

    }else if (disX<0 && disY>=0) {
//        NSLog(@"在第三象限");
        pointO = CGPointMake(pointA.x+5 + (centerDistance / 2)*sinDigree, pointA.y+5 + (centerDistance / 2)*cosDigree);
        pointP = CGPointMake(pointB.x-5 + (centerDistance / 2)*sinDigree, pointB.y-5 + (centerDistance / 2)*cosDigree);
    }else if (disX<0 && disY<=0) {
//        NSLog(@"在第二象限");
        pointO = CGPointMake(pointA.x-5 + (centerDistance / 2)*sinDigree, pointA.y+5 + (centerDistance / 2)*cosDigree);
        pointP = CGPointMake(pointB.x+5 + (centerDistance / 2)*sinDigree, pointB.y-5 + (centerDistance / 2)*cosDigree);

        
    }
    

    [path moveToPoint:pointA];
    [path addQuadCurveToPoint:pointD controlPoint:pointO];
    [path addLineToPoint:pointC];
    [path addQuadCurveToPoint:pointB controlPoint:pointP];
    [path moveToPoint:pointA];
    [self linePathCircleWithPath:path withPoint:self.currentMovingPoint radios:toRadius isFrom:NO];
    [self linePathCircleWithPath:path withPoint:self.oringinCenter radios:r1 isFrom:YES];

   [path closePath];
//    [path fill];
//    [path stroke];
    return path;
}
-(void)linePathCircleWithPath:(UIBezierPath*)path withPoint:(CGPoint)fromPoint radios:(CGFloat)toRadius isFrom:(BOOL)isFrom{
   
    CGFloat cirWid = 0;
    CGFloat cirHei = 0;
    CGFloat radius = 0;
    if (isFrom) {
        cirWid =  2*toRadius;
        cirHei =  2*toRadius;
        radius = toRadius;
    }else{
        CGFloat dis = toRadius - self.radius;
        cirWid =  self.maxWidth+2*dis;
        cirHei =  2*toRadius;
        radius = toRadius;
    }
    CGFloat cirX = fromPoint.x-toRadius;
    CGFloat cirY = fromPoint.y-toRadius;
    UIBezierPath *appPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cirX, cirY, cirWid,cirHei) cornerRadius:radius];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
    CGContextAddPath(ctx, appPath.CGPath);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    

}
#pragma mark - getter
-(UIColor *)borderColor
{
    if (!_borderColor) {
        _borderColor = [UIColor redColor];
    }
    return _borderColor;
}

@end
