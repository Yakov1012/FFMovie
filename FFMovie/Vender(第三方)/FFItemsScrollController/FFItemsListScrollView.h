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

/// 所有items名称数组
@property (nonatomic, strong) NSMutableArray *allItemsNameArr;

/// item点击
@property (nonatomic, copy) void (^operationBlock)(ItemOperationType type, NSString *itemName);

@end
