//
//  ChartView.m
//  FatReduce
//
//  Created by xzm on 2019/10/30.
//  Copyright © 2019 xzm. All rights reserved.
//

#import "ChartView.h"
#import "UIView+DCKit.h"

static CGFloat const mb = 30;
static CGFloat const mw = 30;

@implementation ChartView
{
    NSArray *_dataArray;
    NSMutableArray *_pointArray;
    UIView *_flagLine;
    UILabel *_flagView;
    NSInteger _lastIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lastIndex = -1;
    }
    return self;
}

#pragma mark - Publish
- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray.count == 0) return;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    _flagLine = nil;_flagView = nil;
    if (_lastIndex == -1) _lastIndex = dataArray.count-1;
    //取值
    _dataArray = [dataArray mutableCopy];
    NSMutableArray *valueArray = @[].mutableCopy;
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [valueArray addObject:obj[@"value"]];
    }];
    CGFloat max = [[valueArray valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat min = [[valueArray valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat mh = (H(self) - mb)/3.f;
    CGFloat baseH = H(self) - mh*2 - mb;
    CGFloat baseW = (W(self) - mw*2)/(MAX(1, dataArray.count-1));
    //求点
    _pointArray = @[].mutableCopy;
    [valueArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger i, BOOL * _Nonnull stop) {
        CGFloat px = mw + baseW * i;
        CGFloat py = mh + (1-(obj.floatValue-min)/(MAX(1, max-min)))*baseH;
        [self->_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(px, py)]];
        if (i == 0 || i == valueArray.count - 1) {
            [self addTimeLabelWithText:dataArray[i][@"time"] center:CGPointMake(px, H(self) - mb/2.f)];
        }
        if (valueArray.count > 3 && i == valueArray.count/2) {
            [self addTimeLabelWithText:dataArray[i][@"time"] center:CGPointMake(W(self)/2.f, H(self) - mb/2.f)];
        }
        if (i == 0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, H(self), W(self), 0.5)];
            line.backgroundColor = RGB(216, 216, 216);
            [self addSubview:line];
        }
    }];
    //添加首尾点
    [_pointArray insertObject:[NSValue valueWithCGPoint:CGPointMake(0, CGRectGetHeight(self.bounds)/2.f)] atIndex:0];
    [_pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2.f)]];
    //画路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < valueArray.count - 1; i ++) {
        CGPoint p1 = [[_pointArray objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[_pointArray objectAtIndex:i+1] CGPointValue];
        CGPoint p3 = [[_pointArray objectAtIndex:i+2] CGPointValue];
        CGPoint p4 = [[_pointArray objectAtIndex:i+3] CGPointValue];
        if (i == 0) {
            [path moveToPoint:p2];
        }
        [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
    }
    //绘制
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = RGB(4, 179, 139).CGColor;
    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    lineLayer.lineWidth = 2;
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:lineLayer];
    //动画
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.fromValue = @(0);
    ani.toValue = @(1);
    ani.duration = 1;
    [lineLayer addAnimation:ani forKey:@"strokeEnd"];
    
    [self selectIndex:_lastIndex];
}

#pragma mark - Privite
- (void)addTimeLabelWithText:(NSString *)text center:(CGPoint)center
{
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = [text substringFromIndex:5];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [timeLabel sizeToFit];
    timeLabel.center = center;
    [self addSubview:timeLabel];
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}

- (void)selectIndex:(NSInteger)index
{
    if (!_flagLine) {
        _flagLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, H(self))];
        _flagLine.backgroundColor = RGB(4, 179, 139);
        [self addSubview:_flagLine];
        
        _flagView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        _flagView.backgroundColor = [UIColor whiteColor];
        _flagView.layer.cornerRadius = 5;
        _flagView.layer.masksToBounds = YES;
        _flagView.layer.borderColor = RGB(4, 179, 139).CGColor;
        _flagView.layer.borderWidth = 1;
        _flagView.textAlignment = 1;
        _flagView.numberOfLines = 0;
        _flagView.textColor = RGB(4, 179, 139);
        _flagView.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        [self addSubview:_flagView];
    }
    if (index > _dataArray.count - 1) return;
    CGPoint currentPoint = [_pointArray[index + 1] CGPointValue];
    _flagLine.centerX = _flagView.centerX = currentPoint.x;
    if (_flagView.left < 0) _flagView.left = 0;
    if (_flagView.right > self.width) _flagView.right = self.width;
    NSDictionary *dic = _dataArray[index];
    NSString *time = dic[@"time"];
    NSString *total = [NSString stringWithFormat:@"%@%@\n%@",dic[@"value"],dic[@"type"],time];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:total];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[total rangeOfString:time]];
    _flagView.attributedText = att;
    _lastIndex = index;
}

- (void)showFlagWithTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    CGFloat spaceL = (W(self) - mw*2)/(MAX(1, _dataArray.count-1));
    //获取点击的索引，第一个点只有一半行距可点击，所以需要加上行距一半再计算
    NSInteger index = (point.x - mw + spaceL/2.f)/spaceL;
    [self selectIndex:index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showFlagWithTouch:touches.anyObject];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showFlagWithTouch:touches.anyObject];
}

@end
