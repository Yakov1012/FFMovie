//
//  FFImageUtils.h
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface FFImageUtils : NSObject

/**
 *  拉伸图片
 *
 *  @param image 图片
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizableImage:(UIImage *)image;

/**
 *  根据颜色创建图片
 *
 *  @param color <#color description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name;

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable;

/**
 *  获取指定图径的图片
 *
 *  @param name   路径与图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets;

@end
