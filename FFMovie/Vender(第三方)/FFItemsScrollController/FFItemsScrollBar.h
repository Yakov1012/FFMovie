//
//  FFHorizontalScrollBar.h
//  FFMovie
//
//  Created by Yakov on 15/10/21.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFItemsMacro.h"


/**
 *  横向滚动条
 */
@interface FFItemsScrollBar : UIScrollView

/// 点击item的block回调
@property (nonatomic, copy) void (^itemClickBlock)(NSString *itemName, NSInteger itemIndex);

/// items名称数组
@property (nonatomic, strong) NSMutableArray *itemsNameArr;

/// 被选中的index
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 *  滑动到选中item的位置
 *
 *  @param index 选中item的index
 */
- (void)itemScrollToIndex:(NSInteger)index;

/**
 *  添加新的item
 *
 *  @param itemName 名
 */
- (void)addItem:(NSString *)itemName;

/**
 *  删除item
 *
 *  @param index <#index description#>
 */
- (void)deleteItem:(NSInteger)index;

/**
 *  移动item
 *
 *  @param currentIndex 当前位置
 *  @param index        目标位置
 */
- (void)moveItem:(NSInteger)currentIndex toIndex:(NSInteger)index;

@end
