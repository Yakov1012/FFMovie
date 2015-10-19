//
//  FFImageUtils.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFImageUtils.h"

@implementation FFImageUtils

/**
 *  拉伸图片
 *
 *  @param image 图片
 *
 *  @return <#return value description#>
 */
+ (UIImage *)resizableImage:(UIImage *)image {
    return image = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
}

/**
 *  根据颜色创建图片
 *
 *  @param color <#color description#>
 *  @param size  <#size description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithColor:(UIColor *)color size:(CGSize)size {
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);

        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return img;
    }
}

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name {
    return [self getImageWithNameByPath:name resizable:NO];
}

/**
 *  获取指定图径的图片
 *
 *  @param name 路径与图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable {
    if (name.length == 0) {
        return nil;
    }

    NSString *resourcePath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
    NSString *imagePath;
    if ([name rangeOfString:resourcePath].location != NSNotFound) {
        imagePath = name;
    } else {
        imagePath = [resourcePath stringByAppendingPathComponent:name];
    }

    if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.000000) {
        imagePath = [NSString stringWithFormat:@"%@@2x.png", imagePath];
    }

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (resizable) {
        image = [self resizableImage:image];
    }

    return image;
}

/**
 *  获取指定图径的图片
 *
 *  @param name   路径与图片名称
 *  @param insets <#insets description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)getImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets {
    if (name.length == 0) {
        return nil;
    }

    UIImage *image = [self getImageWithNameByPath:name resizable:NO];
    image = [image resizableImageWithCapInsets:insets];

    return image;
}

@end
