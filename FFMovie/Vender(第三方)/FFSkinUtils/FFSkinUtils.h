//
//  YTSkinUtils.h
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

#import <UIKit/UIKit.h>

/// 皮肤类型
typedef NS_ENUM(NSInteger, SkinType) {
    SkinTypeDay = 0,
    SkinTypeNight = 1,
};


/**
 *  皮肤管理工具
 */
@interface FFSkinUtils : NSObject

/// 皮肤类型
@property (assign, nonatomic) SkinType skinType;
/// 皮肤名称
@property (strong, nonatomic) NSString *skinName;
/// 皮肤配置字典
@property (strong, nonatomic) NSDictionary *skinConfigDic;
/// 皮肤字体配置字典
@property (strong, nonatomic) NSDictionary *skinFontConfigDic;

/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)shareInstance;

/**
 *  获取皮肤字体颜色
 *
 *  @param name 颜色名称
 *
 *  @return <#return value description#>
 */
- (UIColor *)getColorWithNameBySkin:(NSString *)name;

/**
 *  获取皮肤图片
 *
 *  @param name 图片名称
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name;

/**
 *  获取皮肤图片
 *
 *  @param name      图片名称
 *  @param resizable 是否拉伸
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name resizable:(BOOL)resizable;

/**
 *  获取皮肤图片
 *
 *  @param name   图片名称
 *  @param insets UIEdgeInsets
 *
 *  @return <#return value description#>
 */
- (UIImage *)getImageWithNameBySkin:(NSString *)name insets:(UIEdgeInsets)insets;

@end
