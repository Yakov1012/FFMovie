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

/// bottom部分是否隐藏
@property (nonatomic, assign) BOOL isHiddenBottom;

/// 所有items名称数组[@[top部分], @[bottom部分]]
@property (nonatomic, strong) NSMutableArray *allItemsNameArr;

/// item事件，处理完后要传给控制器处理
@property (nonatomic, copy) void (^FFItemListOperationBlock)(ItemOperationType itemOperationType, NSInteger currentIndex, NSInteger toIndex);

@end
