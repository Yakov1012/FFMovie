//
//  FFBaseTabBarController.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFBaseTabBarController.h"
#import "UITabBar+FFExtension.h"

@interface FFBaseTabBarController ()

@end

@implementation FFBaseTabBarController

/**
 *  加载视图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 禁用透明
    self.tabBar.translucent = NO;
    // 超出部分隐藏
    self.tabBar.clipsToBounds = YES;

    // 常态字体
    self.normanlFont = [UIFont systemFontOfSize:12.0];
    // 常态颜色
    self.normanlColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    // 选中颜色
    self.selectedColor = [UIColor colorWithRed:0.00 green:0.40 blue:1.00 alpha:1.00];
}

/**
 *  设置TabBarItem
 *
 *  @param items       items数组(包含要显示文字、图片信息)
 *  @param translucent 图标(tintColor)是否透明
 */
- (void)setUpTabBarItem:(NSArray *)items translucent:(BOOL)translucent {
    if (translucent) {
        // 图片选中颜色透明
        self.tabBar.tintColor = [UIColor clearColor];
    } else {
        // 图片选中颜色不透明
        self.tabBar.tintColor = [UIColor colorWithRed:0.00 green:0.40 blue:1.00 alpha:1.00];
    }

    NSInteger index = 0;
    for (UITabBarItem *item in self.tabBar.items) {
        if (index >= items.count) {
            break;
        }

        NSDictionary *dict = items[index];
        NSString *title = dict[@"Title"];
        UIImage *image = dict[@"Image"];
        UIImage *selectedImage = dict[@"SelectedImage"];

        [item setTitle:title];
        [item setImage:translucent ? [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : image];
        [item setSelectedImage:translucent ? [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] : selectedImage];

        title = nil;
        image = nil;
        selectedImage = nil;
        dict = nil;

        index++;
    }
}

/**
 *  设置小红点
 *
 *  @param index 第几个
 */
- (void)setUpBadgeValue:(NSInteger)index {
    [self setUpBadgeValue:index badgeValue:nil];
}

/**
 *  设置badgeValue
 *
 *  @param index      第几个
 *  @param badgeValue 值
 */
- (void)setUpBadgeValue:(NSInteger)index badgeValue:(NSString *)badgeValue {
    if (index >= self.tabBar.items.count) {
        return;
    }

    if (badgeValue != nil) {
        // 隐藏小红点
        [self.tabBar hideBadgeOnItemIndex:index];

        // 添加badgeValue
        UITabBarItem *item = self.tabBar.items[index];
        item.badgeValue = badgeValue;
    } else {
        // 显示小红点
        [self.tabBar showBadgeOnItemIndex:index];
    }
}

/**
 *  移除 badgeValue | 小红点
 *
 *  @param index 第几个 TabBarItem
 */
- (void)removeBadgeValue:(NSInteger)index {
    if (index >= self.tabBar.items.count) {
        return;
    }

    UITabBarItem *item = self.tabBar.items[index];
    item.badgeValue = nil;

    [self.tabBar hideBadgeOnItemIndex:index];
}

/**
 *  TabBarItem 文字默认字体
 *
 *  @param normanlFont <#normanlFont description#>
 */
- (void)setNormanlFont:(UIFont *)normanlFont {
    _normanlFont = normanlFont;

    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字选中字体
 *
 *  @param selectedFont <#selectedFont description#>
 */
- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;

    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字默认颜色
 *
 *  @param normanlColor <#normanlColor description#>
 */
- (void)setNormanlColor:(UIColor *)normanlColor {
    _normanlColor = normanlColor;

    [self setTabBarItemAttributes];
}

/**
 *  TabBarItem 文字选中颜色
 *
 *  @param selectedColor <#selectedColor description#>
 */
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;

    [self setTabBarItemAttributes];
}

/**
 *  设置 TabBarItem 字体与颜色
 */
- (void)setTabBarItemAttributes {
    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:@{ NSFontAttributeName: self.normanlFont, NSForegroundColorAttributeName: self.normanlColor } forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{ NSFontAttributeName: self.selectedColor, NSForegroundColorAttributeName: self.selectedColor } forState:UIControlStateSelected];
    }
}


@end
