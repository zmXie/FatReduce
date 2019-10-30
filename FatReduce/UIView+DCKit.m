//
//  UIView+DCKit.m
//  Pods
//
//  Created by 黄登登 on 2017/6/6.
//
//

#import "UIView+DCKit.h"

@implementation UIView (DCKit)

#pragma mark - Shortcuts for the coords

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)originX
{
    CGRect rect = self.frame;
    return rect.origin.x;
}

- (CGFloat)originY
{
    CGRect rect = self.frame;
    return rect.origin.y;
}

- (void) setOriginX:(CGFloat)originX
{
    CGRect rect = self.frame;
    rect.origin.x = originX;
    self.frame = rect;
}

- (void) setOriginY:(CGFloat)originY
{
    CGRect rect = self.frame;
    rect.origin.y = originY;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)removeSubviews
{
    NSArray *arrView = self.subviews;
    for (int i = 0; i < arrView.count; i++)
    {
        UIView *view = arrView[i];
        if (view.subviews.count > 0)
        {
            [view removeSubviews];
        }
        
        [view removeFromSuperview];
    }
}

@end