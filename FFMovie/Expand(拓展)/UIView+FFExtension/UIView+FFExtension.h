//
//  UIView+FFExtension.h
//
//
//  Created by Yakov on 15/10/16.
//
//  注意：设置ffRight、ffBottom参数时，请确保宽高已被设置好

#import <UIKit/UIKit.h>

@interface UIView (FFExtension)

/// 视图横坐标
@property (nonatomic, assign) CGFloat ffX;
/// 视图纵坐标
@property (nonatomic, assign) CGFloat ffY;

/// 视图宽
@property (nonatomic, assign) CGFloat ffWidth;
/// 视图高
@property (nonatomic, assign) CGFloat ffHeight;

/// 视图左侧坐标
@property (nonatomic, assign) CGFloat ffLeft;
/// 视图右侧坐标
@property (nonatomic, assign) CGFloat ffRight;
/// 视图顶部坐标
@property (nonatomic, assign) CGFloat ffTop;
/// 视图底部坐标
@property (nonatomic, assign) CGFloat ffBottom;

/// 视图横向中心坐标
@property (nonatomic, assign) CGFloat ffCenterX;
/// 视图纵向中心坐标
@property (nonatomic, assign) CGFloat ffCenterY;

@end
