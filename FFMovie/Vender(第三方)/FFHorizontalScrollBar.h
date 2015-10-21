//
//  FFHorizontalScrollBar.h
//  FFMovie
//
//  Created by Yakov on 15/10/21.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 操作类型
typedef NS_ENUM(NSInteger, AnimateType){
    TopViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4
};


/**
 *  横向滚动条
 */
@interface FFHorizontalScrollBar : UIScrollView

///
@property (nonatomic, copy) void (^arrowChange)();

/// 点击item的block回调
@property (nonatomic, copy) void (^itemClickBlock)(NSString *itemName, NSInteger itemIndex);

/// items名称数组
@property (nonatomic, strong) NSMutableArray *itemsNameArr;

- (void)operationFromBlock:(AnimateType)type itemName:(NSString *)itemName index:(int)index;
- (void)itemClickByScrollerWithIndex:(NSInteger)index;

@end
