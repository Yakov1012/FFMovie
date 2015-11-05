//
//  FFItem.h
//  FFMovie
//
//  Created by Yakov on 15/10/23.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFItemsMacro.h"

#import "FFItemsScrollBar.h"

@interface FFItem : UIButton

/// 名字
@property (nonatomic, copy) NSString *itemName;

/// 当前的item在itemsListScrollView中所处的位置
@property (nonatomic, assign) ItemLocation itemLocation;

/// 拖拽
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

/// item事件
@property (nonatomic, copy) void (^FFItemOperationBlock)(ItemOperationType type, FFItem *item);

@end
