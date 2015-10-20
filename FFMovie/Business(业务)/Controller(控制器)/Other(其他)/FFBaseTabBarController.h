//
//  FFBaseTabBarController.h
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFBaseTabBarController : UITabBarController

/// TabBarItem文字常态字体
@property (strong, nonatomic) UIFont *normalFont;
/// TabBarItem文字选中字体
@property (strong, nonatomic) UIFont *selectedFont;
/// TabBarItem文字常态颜色
@property (strong, nonatomic) UIColor *normalColor;
/// TabBarItem文字选中颜色
@property (strong, nonatomic) UIColor *selectedColor;


/**
 *  设置TabBarItem
 *
 *  @param items       items数组(包含要显示文字、图片信息)
 *  @param translucent 图标(tintColor)是否透明
 */
- (void)setUpTabBarItem:(NSArray *)items translucent:(BOOL)translucent;

/**
 *  设置小红点
 *
 *  @param index 第几个
 */
- (void)setUpBadgeValue:(NSInteger)index;

/**
 *  设置badgeValue
 *
 *  @param index      第几个
 *  @param badgeValue 值
 */
- (void)setUpBadgeValue:(NSInteger)index badgeValue:(NSString *)badgeValue;

/**
 *  移除小红点及badgeValue
 *
 *  @param index 第几个
 */
- (void)removeBadgeValue:(NSInteger)index;


@end
