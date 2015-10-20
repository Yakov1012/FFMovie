//
//  YTSkinUtils.m
//
//  Copyright (c) 2015年 深圳市易图资讯股份有限公司. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "FFSkinUtils.h"

@interface FFSkinUtils ()

/// 资源路径
@property (strong, nonatomic) NSString *resourcePath;

@end

@implementation FFSkinUtils


#pragma mark - 单例
/**
 *  共享(单例方法)
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareInstance {
    static FFSkinUtils *shareInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });

    return shareInstance;
}

/**
 *  初始化
 *
 *  @return <#return value description#>
 */
- (id)init {
    self = [super init];
    if (self != nil) {
        self.resourcePath = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]];
        // 初始化皮肤配置文件
        [self setUpSkinConfig];
        // 设置默认主题
        self.skinName = @"SkinDay";
    }
    return self;
}


#pragma mark - SetUp
/**
 *  获取主题配置文件
 */
- (void)setUpSkinConfig {
    NSString *filePath = [self.resourcePath stringByAppendingPathComponent:@"SkinConfig.plist"];
    self.skinConfigDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
}


#pragma mark - Set
/**
 *  <#Description#>
 *
 *  @param themeName <#themeName description#>
 */
- (void)setSkinName:(NSString *)skinName {
    _skinName = skinName;

    if ([skinName isEqualToString:@"SkinDay"]) {
        self.skinType = SkinTypeDay;
    } else if ([skinName isEqualToString:@"SkinNight"]) {
        self.skinType = SkinTypeNight;
    } else {
        self.skinType = SkinTypeDay;
    }

    // 获取当前皮肤字体配置文件
    [self getFontConfig];
}


#pragma mark - Action
/**
 *  获取当前皮肤路径
 *
 *  @return <#return value description#>
 */
- (NSString *)getSkinPath {
    // 取得当前皮肤子路径
    NSString *subPath = [self.skinConfigDic objectForKey:self.skinName];

    // 皮肤的完整路径
    NSString *path = [self.resourcePath stringByAppendingPathComponent:subPath];

    return path;
}

/**
 *  获取当前主题包的字体配置文件
 */
- (void)getFontConfig {
    NSString *fontConfigPath = [[self getSkinPath] stringByAppendingPathComponent:@"FontColor.plist"];
    self.skinFontConfigDic = [NSDictionary dictionaryWithContentsOfFile:fontConfigPath];
}


/**
 *  获取指定图径的图片
 *
 *  @param name 皮肤文件夹之后的路径(~/SkinDay/name)
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameByPath:(NSString *)name resizable:(BOOL)resizable {
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
        image = [image stretchableImageWithLeftCapWidth:image.size.width / 2.0 topCapHeight:image.size.height / 2.0];
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
- (UIImage *)getImageWithNameByPath:(NSString *)name insets:(UIEdgeInsets)insets {
    if (name.length == 0) {
        return nil;
    }

    UIImage *image = [self getImageWithNameByPath:name resizable:NO];
    image = [image resizableImageWithCapInsets:insets];

    return image;
}


#pragma mark - Public
/**
 *  获取皮肤字体颜色
 *
 *  @param name 颜色名称
 *
 *  @return <#return value description#>
 */
- (UIColor *)getColorWithNameBySkin:(NSString *)name {
    if (name.length == 0) {
        return nil;
    }

    NSString *rgb = [self.skinFontConfigDic objectForKey:name];
    if (!rgb) {
        return nil;
    }

    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count < 3) {
        return nil;
    }

    CGFloat r = [rgbs[0] floatValue];
    CGFloat g = [rgbs[1] floatValue];
    CGFloat b = [rgbs[2] floatValue];

    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
}

/**
 *  获取皮肤图片
 *
 *  @param name 图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name {
    return [self getImageWithNameBySkin:name resizable:NO];
}

/**
 *  获取皮肤图片
 *
 *  @param name      图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name resizable:(BOOL)resizable {
    if (name.length == 0) {
        return nil;
    }

    NSString *imagePath = [[self getSkinPath] stringByAppendingPathComponent:name];
    return [self getImageWithNameByPath:imagePath resizable:resizable];
}

/**
 *  获取皮肤图片
 *
 *  @param name   图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name insets:(UIEdgeInsets)insets {
    if (name.length == 0) {
        return nil;
    }

    NSString *imagePath = [[self getSkinPath] stringByAppendingPathComponent:name];
    return [self getImageWithNameByPath:imagePath insets:insets];
}

@end
