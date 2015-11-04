//
//  FFHorizontalScrollBar.m
//  FFMovie
//
//  Created by Yakov on 15/10/21.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItemsScrollBar.h"


@interface FFItemsScrollBar ()

/// 各个item的X坐标
@property (nonatomic, assign) CGFloat itemX;

/// items数组
@property (nonatomic, strong) NSMutableArray *itemsArr;

/// 被选中的item
@property (nonatomic, strong) UIButton *selectedItem;

/// items的背景视图
@property (nonatomic, strong) UIView *itemsBackgroudView;

@end

@implementation FFItemsScrollBar

#pragma mark - LifeCycle
/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = cRGBColor(238.0, 238.0, 238.0);
        self.showsHorizontalScrollIndicator = NO;

        self.itemX = gEdgeGap;
        self.itemsNameArr = [NSMutableArray arrayWithCapacity:1];
        self.itemsArr = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Set
/**
 *  <#Description#>
 *
 *  @param itemsNameArr <#itemsNameArr description#>
 */
- (void)setItemsNameArr:(NSMutableArray *)itemsNameArr {
    _itemsNameArr = itemsNameArr;

    // 初始化items背景视图(唯一，作为随选中item的背景)
    [self setUpItemsBackgroudView];

    // 初始化item
    for (int i = 0; i < itemsNameArr.count; i++) {
        [self setUpItemWithTitle:itemsNameArr[i]];
    }
}


#pragma mark - SetUp
/**
 *  初始化items背景视图(唯一，作为随选中item的背景)
 */
- (void)setUpItemsBackgroudView {
    if (!self.itemsBackgroudView) {
        self.itemsBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(gEdgeGap / 2.0, (self.frame.size.height - 20) / 2, 46.0, 20.0)];
        self.itemsBackgroudView.backgroundColor = cRGBColor(202.0, 51.0, 54.0);
        self.itemsBackgroudView.layer.cornerRadius = 5;
        [self addSubview:self.itemsBackgroudView];
    }
}

/**
 *  根据标题，初始化item
 *
 *  @param title <#title description#>
 */
- (void)setUpItemWithTitle:(NSString *)title {
    // 计算item的宽度
    CGFloat itemWidth = [self calculateSizeWithFont:sItemFontSize Text:title].size.width;

    // item
    UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(self.itemX, 0, itemWidth, self.frame.size.height)];
    item.titleLabel.font = [UIFont systemFontOfSize:sItemFontSize];
    [item setTitle:title forState:0];
    [item setTitleColor:cRGBColor(111.0, 111.0, 111.0) forState:UIControlStateNormal];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemsArr addObject:item];
    [self addSubview:item];

    // 累加item的X坐标
    self.itemX += (itemWidth + dDistanceBetweenItem);

    // 设置默认选中item
    if (!self.selectedItem) {
        [item setTitleColor:[UIColor whiteColor] forState:0];
        self.selectedItem = item;
        self.selectedIndex = 0;
    }

    // 设置滑动视图的contentSize
    self.contentSize = CGSizeMake(self.itemX - (dDistanceBetweenItem - 20.0), self.frame.size.height);
}

#pragma mark - Action
/**
 *  item点击
 *
 *  @param sender <#sender description#>
 */
- (void)itemClick:(UIButton *)sender {
    // 设置选中item
    if (self.selectedItem != sender) {
        [self.selectedItem setTitleColor:cRGBColor(111.0, 111.0, 111.0) forState:0];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectedItem = sender;
        for (NSInteger i = 0; i < self.itemsArr.count; i++) {
            UIButton *item = self.itemsArr[i];
            if (item == sender) {
                self.selectedIndex = i;
            }
        }

        if (self.itemClickBlock) {
            self.itemClickBlock(sender.titleLabel.text, [self findIndexOfListsWithTitle:sender.titleLabel.text]);
        }
    }


    [UIView animateWithDuration:0.3
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            // items的背景视图位置变化
            CGRect itemsBackgroudViewRect = self.itemsBackgroudView.frame;
            itemsBackgroudViewRect.size.width = sender.frame.size.width + gEdgeGap;
            itemsBackgroudViewRect.origin.x = sender.frame.origin.x - gEdgeGap / 2.0;
            self.itemsBackgroudView.frame = itemsBackgroudViewRect;
        }
        completion:^(BOOL finished) {
            // 内容视图滚动，以保证选中item在合适的位置
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGPoint contentOffset = self.contentOffset;
                                 if (sender.frame.origin.x <= self.frame.size.width / 2.0 && self.contentOffset.x != 0.0) {
                                     contentOffset = CGPointMake(0.0, 0.0);
                                 } else if (sender.frame.origin.x > self.frame.size.width / 2.0 && sender.frame.origin.x <= self.contentSize.width - self.frame.size.width / 2.0 && self.contentSize.width > self.frame.size.width) {
                                     contentOffset = CGPointMake((sender.frame.origin.x - (self.frame.size.width - sender.frame.size.width) / 2.0), 0);
                                 } else if (sender.frame.origin.x > self.frame.size.width / 2.0 && sender.frame.origin.x > self.contentSize.width - self.frame.size.width / 2.0 && self.contentSize.width > self.frame.size.width) {
                                     contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width, 0);
                                 }
                                 self.contentOffset = contentOffset;
                             }];
        }];
}

/**
 *  <#Description#>
 *
 *  @param title <#title description#>
 *
 *  @return <#return value description#>
 */
- (NSInteger)findIndexOfListsWithTitle:(NSString *)title {
    for (int i = 0; i < self.itemsNameArr.count; i++) {
        if ([title isEqualToString:self.itemsNameArr[i]]) {
            return i;
        }
    }
    return 0;
}

/**
 *  根据字体和文字计算Rect
 *
 *  @param Font <#Font description#>
 *  @param Text <#Text description#>
 *
 *  @return <#return value description#>
 */
- (CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text {
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    return size;
}


#pragma mark - Public
/**
 *  滑动到指定位置
 *
 *  @param index <#index description#>
 */
- (void)itemScrollToIndex:(NSInteger)index {
    UIButton *item = (UIButton *)self.itemsArr[index];
    [self itemClick:item];
}

/**
 *  添加item
 *
 *  @param itemName <#itemName description#>
 */
- (void)addItem:(NSString *)itemName {
    [self.itemsNameArr addObject:itemName];

    // 计算item的宽度
    CGFloat itemWidth = [self calculateSizeWithFont:sItemFontSize Text:itemName].size.width;

    // item
    UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(self.itemX, 0, itemWidth, self.frame.size.height)];
    item.titleLabel.font = [UIFont systemFontOfSize:sItemFontSize];
    [item setTitle:itemName forState:0];
    [item setTitleColor:cRGBColor(111.0, 111.0, 111.0) forState:UIControlStateNormal];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.itemsArr addObject:item];
    [self addSubview:item];

    // 累加item的X坐标
    self.itemX += (itemWidth + dDistanceBetweenItem);

    // 设置滑动视图的contentSize
    self.contentSize = CGSizeMake(self.itemX - (dDistanceBetweenItem - 20.0), self.frame.size.height);
}

/**
 *  删除item
 *
 *  @param index <#index description#>
 */
- (void)deleteItem:(NSInteger)index {
    NSString *itemName = self.itemsNameArr[index];
    [self.itemsNameArr removeObjectAtIndex:index];
    UIButton *item = self.itemsArr[index];
    self.selectedIndex = index;
    if (self.selectedItem == item) {
        [self itemScrollToIndex:(index - 1)];
        self.selectedIndex = index - 1;
    }
    [item removeFromSuperview];
    item = nil;
    [self.itemsArr removeObjectAtIndex:index];

    // 计算被删除item所占用的宽度
    CGFloat itemWidth = [self calculateSizeWithFont:sItemFontSize Text:itemName].size.width;
    for (NSInteger i = index; i < self.itemsArr.count; i++) {
        // item
        UIButton *item = self.itemsArr[i];
        CGRect itemRect = item.frame;
        itemRect.origin.x -= (itemWidth + dDistanceBetweenItem);
        item.frame = itemRect;
    }
    self.itemX -= (itemWidth + dDistanceBetweenItem);
    self.contentSize = CGSizeMake(self.itemX - (dDistanceBetweenItem - 20.0), self.frame.size.height);

    // 移动背景
    for (NSInteger i = 0; i < self.itemsArr.count; i++) {
        UIButton *item = self.itemsArr[i];
        if (self.selectedItem == item) {
            [self itemScrollToIndex:i];
            self.selectedIndex = i;
            break;
        }
    }
}

/**
 *  移动item
 *
 *  @param currentIndex 当前位置
 *  @param index        目标位置
 */
- (void)moveItem:(NSInteger)currentIndex toIndex:(NSInteger)index {
    // items数组
    NSObject *itemNameObject = self.itemsNameArr[currentIndex];
    [self.itemsNameArr removeObjectAtIndex:currentIndex];
    [self.itemsNameArr insertObject:itemNameObject atIndex:index];

    // 起点
    NSInteger startPoint;
    // 终点
    NSInteger endPoint;

    if (currentIndex <= index) {
        startPoint = currentIndex;
        endPoint = index;

    } else {
        startPoint = index;
        endPoint = currentIndex;
    }

    // 开始的button
    UIButton *starItem = self.itemsArr[startPoint];

    //  items数组处理
    NSObject *itemObject = self.itemsArr[currentIndex];
    [self.itemsArr removeObjectAtIndex:currentIndex];
    [self.itemsArr insertObject:itemObject atIndex:index];

    CGRect starItemRect = starItem.frame;
    for (NSInteger i = startPoint; i <= endPoint; i++) {
        NSString *itemName = self.itemsNameArr[i];
        CGFloat itemWidth = [self calculateSizeWithFont:sItemFontSize Text:itemName].size.width;
        starItemRect.size.width = itemWidth;

        UIButton *item = self.itemsArr[i];
        self.selectedIndex = (self.selectedItem == item) ? i : self.selectedIndex;
        item.frame = starItemRect;

        starItemRect.origin.x += (starItemRect.size.width + dDistanceBetweenItem);
    }

    [self itemScrollToIndex:self.selectedIndex];
}

@end
