//
//  UIView+FFExtension.m
//
//
//  Created by Yakov on 15/10/16.
//
//

#import "UIView+FFExtension.h"

@implementation UIView (FFExtension)

#pragma mark - 视图横坐标
- (CGFloat)ffX {
    return self.frame.origin.x;
}

- (void)setFfX:(CGFloat)ffX {
    CGRect frame = self.frame;
    frame.origin.x = ffX;
    self.frame = frame;
}


#pragma mark - 视图纵坐标
- (CGFloat)ffY {
    return self.frame.origin.y;
}

- (void)setFfY:(CGFloat)ffY {
    CGRect frame = self.frame;
    frame.origin.y = ffY;
    self.frame = frame;
}


#pragma mark - 视图宽
- (CGFloat)ffWidth {
    return self.frame.size.width;
}

- (void)setFfWidth:(CGFloat)ffWidth {
    CGRect frame = self.frame;
    frame.size.width = ffWidth;
    self.frame = frame;
}


#pragma mark - 视图高
- (CGFloat)ffHeight {
    return self.frame.size.height;
}

- (void)setFfHeight:(CGFloat)ffHeight {
    CGRect frame = self.frame;
    frame.size.height = ffHeight;
    self.frame = frame;
}


#pragma mark - 视图左侧坐标
- (CGFloat)ffLeft {
    return self.frame.origin.x;
}

- (void)setFfLeft:(CGFloat)ffLeft {
    CGRect frame = self.frame;
    frame.origin.x = ffLeft;
    self.frame = frame;
}


#pragma mark - 视图右侧坐标
- (CGFloat)ffRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFfRight:(CGFloat)ffRight {
    CGRect frame = self.frame;
    frame.origin.x = ffRight - frame.size.width;
    self.frame = frame;
}


#pragma mark - 视图顶部坐标
- (CGFloat)ffTop {
    return self.frame.origin.y;
}

- (void)setFfTop:(CGFloat)ffTop {
    CGRect frame = self.frame;
    frame.origin.y = ffTop;
    self.frame = frame;
}


#pragma mark - 视图底部坐标
- (CGFloat)ffBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFfBottom:(CGFloat)ffBottom {
    CGRect frame = self.frame;
    frame.origin.y = ffBottom - frame.size.height;
    self.frame = frame;
}


#pragma mark - 视图横向中心坐标
- (CGFloat)ffCenterX {
    return self.center.x;
}

- (void)setFfCenterX:(CGFloat)ffCenterX {
    CGPoint tmpCenter = self.center;
    tmpCenter.x = ffCenterX;
    self.center = tmpCenter;
}


#pragma mark - 视图纵向中心坐标
- (CGFloat)ffCenterY {
    return self.center.y;
}

- (void)setFfCenterY:(CGFloat)ffCenterY {
    CGPoint tmpCenter = self.center;
    tmpCenter.y = ffCenterY;
    self.center = tmpCenter;
}

@end
