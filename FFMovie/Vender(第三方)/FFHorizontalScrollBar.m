//
//  FFHorizontalScrollBar.m
//  FFMovie
//
//  Created by Yakov on 15/10/21.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFHorizontalScrollBar.h"

#define dDistanceBetweenItem 32.0
#define gGapFromEdge 20.0
#define sItemFontSize 13.0
#define cRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1.0]

@interface FFHorizontalScrollBar ()

/// 各个item的X坐标
@property (nonatomic, assign) CGFloat itemX;

/// items数组
@property (nonatomic, strong) NSMutableArray *itemsArr;

/// 被选中的item
@property (nonatomic, strong) UIButton *selectedItem;

/// items的背景视图
@property (nonatomic, strong) UIView *itemsBackgroudView;

@end

@implementation FFHorizontalScrollBar

#pragma mark - LifeCycle
/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = cRGBColor(238.0, 238.0, 238.0);
        //        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;

        self.itemX = gGapFromEdge;
        self.itemsNameArr = [NSMutableArray arrayWithCapacity:1];
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
        self.itemsBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(gGapFromEdge / 2.0, (self.frame.size.height - 20) / 2, 46.0, 20.0)];
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
    [item setTitleColor:cRGBColor(111.0, 111.0, 111.0) forState:0];
    [item setTitleColor:cRGBColor(111.0, 111.0, 111.0) forState:1 << 0];
    [item setTitleColor:[UIColor whiteColor] forState:1 << 2];
    [item addTarget:self action:@selector(itemClick:) forControlEvents:1 << 6];
    [self.itemsArr addObject:item];
    [self addSubview:item];

    // 累加item的X坐标
    self.itemX += (itemWidth + dDistanceBetweenItem);

    // 设置默认选中item
    if (!self.selectedItem) {
        [item setTitleColor:[UIColor whiteColor] forState:0];
        self.selectedItem = item;
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
            itemsBackgroudViewRect.size.width = sender.frame.size.width + gGapFromEdge;
            itemsBackgroudViewRect.origin.x = sender.frame.origin.x - gGapFromEdge / 2.0;
            self.itemsBackgroudView.frame = itemsBackgroudViewRect;
        }
        completion:^(BOOL finished) {
            // 内容视图滚动，以保证选中item在合适的位置
            [UIView animateWithDuration:0.3
                             animations:^{
                                 CGPoint contentOffset = self.contentOffset;

                                 if (sender.frame.origin.x <= wScreenWidth / 2.0 && self.contentOffset.x != 0.0) {
                                     contentOffset = CGPointMake(0.0, 0.0);
                                 } else if (sender.frame.origin.x > wScreenWidth / 2.0 && sender.frame.origin.x <= self.contentSize.width - wScreenWidth / 2.0 && self.contentSize.width > wScreenWidth) {
                                     contentOffset = CGPointMake((sender.frame.origin.x - (wScreenWidth - sender.frame.size.width) / 2.0), 0);
                                 } else if (sender.frame.origin.x > wScreenWidth / 2.0 && sender.frame.origin.x > self.contentSize.width - wScreenWidth / 2.0 && self.contentSize.width > wScreenWidth) {
                                     contentOffset = CGPointMake(self.contentSize.width - wScreenWidth, 0);
                                 }
                                 self.contentOffset = contentOffset;
                             }];
        }];
}

- (void)switchPositionWithItemName:(NSString *)itemName index:(NSInteger)index {
    UIButton *button = self.itemsArr[[self findIndexOfListsWithTitle:itemName]];
    [self.itemsNameArr removeObject:itemName];
    [self.itemsArr removeObject:button];
    [self.itemsNameArr insertObject:itemName atIndex:index];
    [self.itemsArr insertObject:button atIndex:index];
    [self itemClick:self.selectedItem];
    [self resetFrame];
}

- (void)removeItemWithTitle:(NSString *)title {
    NSInteger index = [self findIndexOfListsWithTitle:title];
    UIButton *select_button = self.itemsArr[index];
    [self.itemsArr[index] removeFromSuperview];
    [self.itemsArr removeObject:select_button];
    [self.itemsNameArr removeObject:title];
}

- (NSInteger)findIndexOfListsWithTitle:(NSString *)title {
    for (int i = 0; i < self.itemsNameArr.count; i++) {
        if ([title isEqualToString:self.itemsNameArr[i]]) {
            return i;
        }
    }
    return 0;
}

- (void)resetFrame {
    self.itemX = 20;
    for (int i = 0; i < self.itemsNameArr.count; i++) {
        [UIView animateWithDuration:0.0001
            delay:0
            options:UIViewAnimationOptionLayoutSubviews
            animations:^{
                CGFloat itemW = [self calculateSizeWithFont:sItemFontSize Text:self.itemsNameArr[i]].size.width;
                [[self.itemsArr objectAtIndex:i] setFrame:CGRectMake(self.itemX, 0, itemW, self.frame.size.height)];
                self.itemX += dDistanceBetweenItem + itemW;
            }
            completion:^(BOOL finished){
            }];
    }
    self.contentSize = CGSizeMake(self.itemX, self.frame.size.height);
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
- (void)itemClickByScrollerWithIndex:(NSInteger)index {
    UIButton *item = (UIButton *)self.itemsArr[index];
    [self itemClick:item];
}


- (void)operationFromBlock:(AnimateType)type itemName:(NSString *)itemName index:(int)index {
    switch (type) {
    case TopViewClick: // 点击
        [self itemClick:self.itemsArr[[self findIndexOfListsWithTitle:itemName]]];
        if (self.arrowChange) {
            self.arrowChange();
        }
        break;
    case FromTopToTop:
        [self switchPositionWithItemName:itemName index:index];
        break;
    case FromTopToTopLast:
        [self switchPositionWithItemName:itemName index:self.itemsNameArr.count - 1];
        break;
    case FromTopToBottomHead:
        if ([self.selectedItem.titleLabel.text isEqualToString:itemName]) {
            [self itemClick:self.itemsArr[0]];
        }
        [self removeItemWithTitle:itemName];
        [self resetFrame];
        break;
    case FromBottomToTopLast:
        [self.itemsNameArr addObject:itemName];
        [self setUpItemWithTitle:itemName];
        break;
    default:
        break;
    }
}

@end
