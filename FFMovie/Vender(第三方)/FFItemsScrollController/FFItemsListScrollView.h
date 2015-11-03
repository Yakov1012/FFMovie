//
//  FFItemsManageScrollView.h
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFItemsMacro.h"

#import "FFItemsScrollBar.h"

@interface FFItemsListScrollView : UIScrollView

/// 是否隐藏bottom部分
@property (nonatomic, assign) BOOL isHiddenBottom;

/// 所有items名称数组[@[], @[]]
@property (nonatomic, strong) NSMutableArray *allItemsNameArr;

/// item事件（top部分点击，top部分删除，top部分移动，bottom部分点击）
@property (nonatomic, copy) void (^FFItemListOperationBlock)(ItemOperationType itemOperationType, NSInteger currentIndex, NSInteger toIndex);

@end
