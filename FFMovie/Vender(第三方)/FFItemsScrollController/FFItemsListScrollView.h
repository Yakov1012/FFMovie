//
//  FFItemsManageScrollView.h
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFItemsScrollBar.h"

@interface FFItemsListScrollView : UIScrollView

@property (nonatomic, strong) NSMutableArray *topView;
@property (nonatomic, strong) NSMutableArray *bottomView;

/// 所有items名称数组
@property (nonatomic, strong) NSMutableArray *allItemsNameArr;


@property (nonatomic, copy) void (^longPressedBlock)();
@property (nonatomic, copy) void (^opertionFromItemBlock)(AnimateType type, NSString *itemName, int index);
- (void)itemRespondFromListBarClickWithItemName:(NSString *)itemName;

@end
