//
//  HQliquidAnimationView.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "HQliquidAnimationView.h"

#define kFromRadiusScaleCoefficient     0.1f
#define kToRadiusScaleCoefficient       0.1f
#define kMaxDistanceScaleCoefficient    9.0f

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
        BOOL isOverNumber = self.badgeNumber>99?YES:NO;
        NSString *titleMaking = isOverNumber?[NSString stringWithFormat:@"%@",@"99+"]:[NSString stringWithFormat:@"%ld",self.badgeNumber];
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
        NSString *titleMaking = isOverNumber?[NSString stringWithFormat:@"%@",@"99+"]:[NSString stringWithFormat:@"%ld",self.badgeNumber];
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
    _toRadius = self.radius*0.5-kToRadiusScaleCoefficient*r;
    _viscosity = 1.0-r/_maxDistance;
    
    [self setNeedsDisplay];
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
   CGFloat centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
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
    
   CGFloat  r1 = fromRadius;
   CGFloat  r2 = toRadius;
   CGPoint  pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
   CGPoint pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
   CGPoint pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
   CGPoint pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
   CGPoint pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
   CGPoint pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    

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
//    CGFloat r = distanceBetweenPoints(fromPoint, toPoint);
//    CGFloat offsetY = fabs(fromRadius-toRadius);
//    if (r <= offsetY) {
//        CGPoint center;
//        CGFloat radius;
//        if (fromRadius >= toRadius) {
//            center = fromPoint;
//            radius = fromRadius;
//        } else {
//            center = toPoint;
//            radius = toRadius;
//        }
//        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    } else {
//        CGFloat originX = toPoint.x - fromPoint.x;
//        CGFloat originY = toPoint.y - fromPoint.y;
//
//        CGFloat fromOriginAngel = (originX >= 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
//        CGFloat fromOffsetAngel = (fromRadius >= toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
//        CGFloat fromStartAngel = fromOriginAngel + fromOffsetAngel;
//        CGFloat fromEndAngel = fromOriginAngel - fromOffsetAngel;
//
//        CGPoint fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
//
//        CGFloat toOriginAngel = (originX < 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
//        CGFloat toOffsetAngel = (fromRadius < toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
//        CGFloat toStartAngel = toOriginAngel + toOffsetAngel;
//        CGFloat toEndAngel = toOriginAngel - toOffsetAngel;
//        CGPoint toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
//
//        CGPoint middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
//        CGFloat middleRadius = (fromRadius+toRadius)/2;
//
//        CGPoint fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
//
//        CGPoint toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
//
//        [path moveToPoint:fromStartPoint];
//
//        [path addArcWithCenter:fromPoint radius:fromRadius startAngle:fromStartAngel endAngle:fromEndAngel clockwise:YES];
//
//        if (r > (fromRadius+toRadius)) {
//            [path addQuadCurveToPoint:toStartPoint controlPoint:fromControlPoint];
//            [path addLineToPoint:CGPointMake(toStartPoint.x, toStartPoint.y+2*fromRadius)];
//        }
//
//        [path addArcWithCenter:toPoint radius:toRadius startAngle:toStartAngel endAngle:toEndAngel clockwise:YES];
////         [self linePathCircleWithPath:path withPoint:toPoint];
//
//        if (r > (fromRadius+toRadius)) {
//            [path addQuadCurveToPoint:fromStartPoint controlPoint:toControlPoint];
//        }
//    }
//

@end
