//
//  FFItemsMacro.h
//  FFMovie
//
//  Created by Yakov on 15/10/23.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#ifndef FFItemsMacro_h
#define FFItemsMacro_h

/// 操作类型
typedef NS_ENUM(NSInteger, ItemOperationType) {
    ItemOperationTypeTopClick = 0,   // top部分点击
    ItemOperationTypeDelete = 2,     // top部分删除
    ItemOperationTypeMove = 3,       // top部分移动
    ItemOperationTypeBottomClick = 1 // bottom部分点击
};

/// 当前的item在itemsListScrollView中所处的位置
typedef NS_ENUM(NSInteger, ItemLocation) {
    ItemLocationTop = 0,   // item位于top部分
    ItemLocationBottom = 1 // item位于bottom部分
};

/// 管理排序的通知
#define nManagerNotification @"nManagerNotification"

/// items滑动条相邻两item之间的距离
#define dDistanceBetweenItem 32.0

/// 边界距离
#define gEdgeGap 20.0

/// items字体大小
#define sItemFontSize 13.0

/// 展开、收起按钮的宽和高
#define hArrowHeight 30.0
#define wArrowWidth 30.0

/// itemsListScrollView中每行的item数、及item的宽和高
#define wMyScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define hMyScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define itemsPerLine 4
#define wItemWidth (wMyScreenWidth - gEdgeGap * (itemsPerLine + 1)) / itemsPerLine
#define hItemHight 25.0

/// 颜色
#define cRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

#endif /* FFItemsMacro_h */
