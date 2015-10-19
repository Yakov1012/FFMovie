//
//  UITabBar+FFExtension.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "UITabBar+FFExtension.h"

#define tBadgeTag 999

@implementation UITabBar (FFExtension)

/**
 *  显示小红点
 *
 *  @param index <#index description#>
 */
- (void)showBadgeOnItemIndex:(NSInteger)index {
    if (index >= self.items.count) {
        return;
    }

    // iPad 兼容处理
    CGFloat rectX = (self.frame.size.width - 640.0) / 2.0 - 13.0;

    // 移除之前的小红点
    [self removeBadgeOnItemIndex:index];

    // 新建小红点
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = tBadgeTag + index;
    // 圆形
    badgeView.layer.cornerRadius = 5.0;
    // 颜色：红色
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;

    // 确定小红点的位置
    CGFloat percentX = (index + 0.6) / self.items.count;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    // 圆形大小为10
    badgeView.frame = CGRectMake(x - ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ? rectX : 0.0), y, 10.0, 10.0);
    [self addSubview:badgeView];
}

/**
 *  隐藏小红点
 *
 *  @param index <#index description#>
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index {
    [self removeBadgeOnItemIndex:index];
}

/**
 *  移除小红点
 *
 *  @param index <#index description#>
 */
- (void)removeBadgeOnItemIndex:(NSInteger)index {
    if (index >= self.items.count) {
        return;
    }

    // 移除 badgeValue
    UITabBarItem *item = self.items[index];
    item.badgeValue = nil;

    // 按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == tBadgeTag + index) {
            [subView removeFromSuperview];
        }
    }
}


@end
