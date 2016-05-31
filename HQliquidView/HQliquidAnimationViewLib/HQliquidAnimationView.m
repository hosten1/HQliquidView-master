//
//  HQliquidAnimationView.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "HQliquidAnimationView.h"

#define kFromRadiusScaleCoefficient     0.09f
#define kToRadiusScaleCoefficient       0.05f
#define kMaxDistanceScaleCoefficient    8.0f

static inline CGFloat distanceBetweenPoints (CGPoint pointA, CGPoint pointB) {
    CGFloat deltaX = pointB.x - pointA.x;
    CGFloat deltaY = pointB.y - pointA.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
};

@interface HQliquidAnimationView()

@property (nonatomic, assign) float fromRadius;
@property (nonatomic, assign) float toRadius;

@property (nonatomic, assign) float viscosity;

@property (nonatomic, assign) float currentDistance;

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

-(void)setCurrentDistance:(float)currentDistance
{
    _currentDistance = currentDistance;
    if (_currentDistance > _maxDistance) {
        _currentState = HQliquidAnimationViewStateSeperated;
    }
}

-(void)setRadius:(float)radius
{
    _radius = radius;
    _maxDistance = kMaxDistanceScaleCoefficient * _radius;
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
        NSString *titleMaking =  self.badgeNumber;
        NSDictionary *attributesMaking = @{
                                           NSParagraphStyleAttributeName:paragraphMaking,
                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                           NSForegroundColorAttributeName:[UIColor whiteColor],
                                           };
        CGFloat x = [self.badgeNumber floatValue]>=10?([self.badgeNumber isEqualToString:@"99+"]?_currentMovingPoint.x-self.radius*2.0:_currentMovingPoint.x-self.radius*1.7):_currentMovingPoint.x-self.radius*1.2;
        [titleMaking drawInRect:CGRectMake(x, _currentMovingPoint.y-7, _maxWidth, self.radius*2) withAttributes:attributesMaking];
        
    }else{//未分离
        
        UIBezierPath* path = [self bezierPathWithFromPoint:_oringinCenter toPoint:_currentMovingPoint fromRadius:_fromRadius toRadius:_toRadius scale:_viscosity];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, self.borderColor.CGColor);
        CGContextSetLineWidth(ctx, 1);
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
        CGContextAddPath(ctx, path.CGPath);
        CGContextDrawPath(ctx, kCGPathFillStroke);
        
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
    _fromRadius = self.radius-kFromRadiusScaleCoefficient*r;
    _toRadius = self.radius-kToRadiusScaleCoefficient*r;
    _viscosity = 1.0-r/_maxDistance;
    
    [self setNeedsDisplay];
}

- (UIBezierPath* )bezierPathWithFromPoint:(CGPoint)fromPoint
                                  toPoint:(CGPoint)toPoint
                               fromRadius:(CGFloat)fromRadius
                                 toRadius:(CGFloat)toRadius scale:(CGFloat)scale{
    UIBezierPath* path = [[UIBezierPath alloc] init];
    CGFloat r = distanceBetweenPoints(fromPoint, toPoint);
    CGFloat offsetY = fabs(fromRadius-toRadius);
    if (r <= offsetY) {
        CGPoint center;
        CGFloat radius;
        if (fromRadius >= toRadius) {
            center = fromPoint;
            radius = fromRadius;
        } else {
            center = toPoint;
            radius = toRadius;
        }
        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    } else {
        CGFloat originX = toPoint.x - fromPoint.x;
        CGFloat originY = toPoint.y - fromPoint.y;
        
        CGFloat fromOriginAngel = (originX >= 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat fromOffsetAngel = (fromRadius >= toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat fromStartAngel = fromOriginAngel + fromOffsetAngel;
        CGFloat fromEndAngel = fromOriginAngel - fromOffsetAngel;
        
        CGPoint fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
        
        CGFloat toOriginAngel = (originX < 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat toOffsetAngel = (fromRadius < toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat toStartAngel = toOriginAngel + toOffsetAngel;
        CGFloat toEndAngel = toOriginAngel - toOffsetAngel;
        CGPoint toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
        
        CGPoint middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
        CGFloat middleRadius = (fromRadius+toRadius)/2;
        
        CGPoint fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
        
        CGPoint toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
        
        [path moveToPoint:fromStartPoint];
        
        [path addArcWithCenter:fromPoint radius:fromRadius startAngle:fromStartAngel endAngle:fromEndAngel clockwise:YES];
        
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:toStartPoint controlPoint:fromControlPoint];
        }
        
        [path addArcWithCenter:toPoint radius:toRadius startAngle:toStartAngel endAngle:toEndAngel clockwise:YES];
        
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:fromStartPoint controlPoint:toControlPoint];
        }
    }
    
    [path closePath];
    
    return path;
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
