//
//  UITabBar+FFExtension.h
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (FFExtension)

/**
 *  显示小红点
 *
 *  @param index <#index description#>
 */
- (void)showBadgeOnItemIndex:(NSInteger)index;

/**
 *  隐藏小红点
 *
 *  @param index <#index description#>
 */
- (void)hideBadgeOnItemIndex:(NSInteger)index;


@end
