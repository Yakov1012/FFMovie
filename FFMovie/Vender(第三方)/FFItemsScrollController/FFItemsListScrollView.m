//
//  FFItemsManageScrollView.m
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItemsListScrollView.h"

#import "FFItem.h"


@interface FFItemsListScrollView ()

/// top部分底视图
@property (nonatomic, strong) UIView *topView;
/// bottom部分底视图
@property (nonatomic, strong) UIView *bottomView;

/// top部分的items
@property (nonatomic, strong) NSMutableArray *topItemsArr;
/// bottom部分的items
@property (nonatomic, strong) NSMutableArray *bottomItemsArr;

/// top部分视图的高度
@property (nonatomic, assign) CGFloat topViewHeight;
/// bottom部分视图的高度
@property (nonatomic, assign) CGFloat bottomViewHeight;

@end

@implementation FFItemsListScrollView

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
        self.showsVerticalScrollIndicator = NO;

        // 设置背景色，子视图的透明度不受影响
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];

        // bottom部分隐藏
        self.isHiddenBottom = NO;

        // items数组
        self.topItemsArr = [NSMutableArray arrayWithCapacity:0];
        self.bottomItemsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - Set
/**
 *  <#Description#>
 *
 *  @param allItemsNameArr <#allItemsNameArr description#>
 */
- (void)setAllItemsNameArr:(NSMutableArray *)allItemsNameArr {
    _allItemsNameArr = allItemsNameArr;

    NSArray *topItemsNameArr = allItemsNameArr[0];
    NSArray *bottomItemsNameArr = allItemsNameArr[1];

    // top部分的高度
    self.topViewHeight = gEdgeGap + (gEdgeGap + hItemHight) * ((topItemsNameArr.count - 1) / itemsPerLine + 1);
    // bottom部分的高度
    self.bottomViewHeight = gEdgeGap + (gEdgeGap + hItemHight) * ((bottomItemsNameArr.count - 1) / itemsPerLine + 1) + hArrowHeight;

    // 内容视图的高度
    CGFloat contentSizeHight = self.isHiddenBottom ? self.topViewHeight : (self.topViewHeight + self.bottomViewHeight);
    self.contentSize = CGSizeMake(wMyScreenWidth, MAX(contentSizeHight, self.frame.size.height));

    // 初始化top、bottom
    [self setUpTopView];
    [self setUpBottomView];
}

/**
 *  <#Description#>
 *
 *  @param isHiddenBottom <#isHiddenBottom description#>
 */
- (void)setIsHiddenBottom:(BOOL)isHiddenBottom {
    _isHiddenBottom = isHiddenBottom;

    if (_isHiddenBottom) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }

    // 内容视图的高度
    CGFloat contentSizeHight = self.isHiddenBottom ? self.topViewHeight : (self.topViewHeight + self.bottomViewHeight);
    self.contentSize = CGSizeMake(wMyScreenWidth, MAX(contentSizeHight, self.frame.size.height));
}


#pragma mark - SetUp
/**
 *  初始化top部分底视图
 */
- (void)setUpTopView {
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.topViewHeight)];
    [self addSubview:self.topView];

    // 添加items
    NSArray *topItemsNameArr = self.allItemsNameArr[0];
    for (int i = 0; i < topItemsNameArr.count; i++) {
        CGFloat itemX = gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine);
        CGFloat itemY = gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine);

        // 初始化ffItem
        FFItem *item = [[FFItem alloc] initWithFrame:CGRectMake(itemX, itemY, wItemWidth, hItemHight)];
        item.itemName = topItemsNameArr[i];
        item.itemLocation = ItemLocationTop;

        // ffItem回调
        sWeakBlock(weakSelf);
        sStrongBlock(strongSelf);
        item.FFItemOperationBlock = ^(ItemOperationType itemOperationType, FFItem *item) {
            // top部分点击
            if (itemOperationType == ItemOperationTypeTopClick) {
                [strongSelf topItemClick:item];
            }

            // top部分删除
            else if (itemOperationType == ItemOperationTypeDelete) {
                [strongSelf deleteButtonClick:item];
            }

            // top部分移动
            else if (itemOperationType == ItemOperationTypeMove) {
                [strongSelf moveItem:item];
            }

            // bottom部分点击
            else if (itemOperationType == ItemOperationTypeBottomClick) {
                [strongSelf bottomItemClick:item];
            }
        };
        [self.topView addSubview:item];
        [self.topItemsArr addObject:item];

        // 设置选中item
        if ([item.itemName isEqualToString:@"推荐"]) {
            [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

/**
 *  初始化bottom部分底视图
 */
- (void)setUpBottomView {
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.topViewHeight, self.frame.size.width, self.bottomViewHeight)];
    [self insertSubview:self.bottomView belowSubview:self.topView];

    // bottom部分头部
    UIView *bottomHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, wMyScreenWidth, hArrowHeight)];
    bottomHeaderView.tag = 999;
    bottomHeaderView.backgroundColor = [UIColor grayColor];
    UILabel *moreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 100.0, bottomHeaderView.frame.size.height)];
    moreTextLabel.text = @"点击添加频道";
    moreTextLabel.font = [UIFont systemFontOfSize:14];
    [bottomHeaderView addSubview:moreTextLabel];
    [self.bottomView addSubview:bottomHeaderView];

    // 添加items
    NSArray *bottomItemsNameArr = self.allItemsNameArr[1];
    for (int i = 0; i < bottomItemsNameArr.count; i++) {
        CGFloat itemX = gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine);
        CGFloat itemY = bottomHeaderView.frame.origin.y + bottomHeaderView.frame.size.height + gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine);

        // 初始化ffItem
        FFItem *item = [[FFItem alloc] initWithFrame:CGRectMake(itemX, itemY, wItemWidth, hItemHight)];
        item.itemName = bottomItemsNameArr[i];
        item.itemLocation = ItemLocationBottom;

        // ffItem回调
        sWeakBlock(weakSelf);
        sStrongBlock(strongSelf);
        item.FFItemOperationBlock = ^(ItemOperationType itemOperationType, FFItem *item) {
            // top部分点击
            if (itemOperationType == ItemOperationTypeTopClick) {
                [strongSelf topItemClick:item];
            }

            // top部分删除
            else if (itemOperationType == ItemOperationTypeDelete) {
                [strongSelf deleteButtonClick:item];
            }

            // top部分移动
            else if (itemOperationType == ItemOperationTypeMove) {
                [strongSelf moveItem:item];
            }

            // bottom部分点击
            else if (itemOperationType == ItemOperationTypeBottomClick) {
                [strongSelf bottomItemClick:item];
            }
        };
        [self.bottomView addSubview:item];
        [self.bottomItemsArr addObject:item];
    }
}


#pragma mark - Action
/**
 *  top部分点击
 *
 *  @param item <#item description#>
 */
- (void)topItemClick:(FFItem *)item {
    // items数组相应变化，及获取当前操作的item的位置
    __block NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.topItemsArr.count; i++) {
        if (self.topItemsArr[i] == item) {
            currentIndex = i;
            break;
        }
    }

    if (self.FFItemListOperationBlock) {
        self.FFItemListOperationBlock(ItemOperationTypeTopClick, currentIndex, currentIndex);
    }
}

/**
 *  top部分删除
 *
 *  @param item <#item description#>
 */
- (void)deleteButtonClick:(FFItem *)item {
    // items数组相应变化，及获取当前操作的item的位置
    __block NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.topItemsArr.count; i++) {
        if (self.topItemsArr[i] == item) {
            currentIndex = i;
            [self.topItemsArr removeObject:item];
            [self.bottomItemsArr insertObject:item atIndex:0];
            break;
        }
    }
    [item removeFromSuperview];

    // 改变item的top|bottom
    item.itemLocation = ItemLocationBottom;
    [self.bottomView addSubview:item];

    // topView、bottomView的frame变化
    self.topViewHeight = self.topItemsArr.count == 0 ? 0.0 : (gEdgeGap + (gEdgeGap + hItemHight) * ((self.topItemsArr.count - 1) / itemsPerLine + 1));
    self.bottomViewHeight = gEdgeGap + (gEdgeGap + hItemHight) * ((self.bottomItemsArr.count - 1) / itemsPerLine + 1) + hArrowHeight;

    CGRect topViewRect = self.topView.frame;
    topViewRect.size.height = self.topViewHeight;
    self.topView.frame = topViewRect;

    CGRect bottomViewRect = self.bottomView.frame;
    bottomViewRect.origin.y = self.topViewHeight;
    bottomViewRect.size.height = self.bottomViewHeight;
    self.bottomView.frame = bottomViewRect;

    // 内容视图的高度
    CGFloat contentSizeHight = self.isHiddenBottom ? self.topViewHeight : (self.topViewHeight + self.bottomViewHeight);
    self.contentSize = CGSizeMake(wMyScreenWidth, MAX(contentSizeHight, self.frame.size.height));

    // 如果top部分无item，隐藏提示View
    UIView *bottomHeaderView = [self.bottomView viewWithTag:999];
    bottomHeaderView.hidden = self.topItemsArr.count == 0 ? YES : NO;

    // top部分，item坐标变化
    [UIView animateWithDuration:0.3
        delay:0
        options:UIViewAnimationOptionLayoutSubviews
        animations:^{
            for (int i = 0; i < self.topItemsArr.count; i++) {
                FFItem *item = (FFItem *)self.topItemsArr[i];
                CGRect itemRect = item.frame;
                itemRect.origin.x = gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine);
                itemRect.origin.y = gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine);
                item.frame = itemRect;
            }
        }
        completion:^(BOOL finished) {
            if (self.FFItemListOperationBlock) {
                self.FFItemListOperationBlock(ItemOperationTypeDelete, currentIndex, currentIndex);
            }
        }];

    // bottom部分，item坐标变化
    for (NSInteger i = 0; i < self.bottomItemsArr.count; i++) {
        FFItem *item = (FFItem *)self.bottomItemsArr[i];
        CGRect itemRect = item.frame;
        itemRect.origin.x = gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine);
        itemRect.origin.y = bottomHeaderView.frame.origin.y + bottomHeaderView.frame.size.height + gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine);
        item.frame = itemRect;
    }
}

/**
 *  top部分移动
 *
 *  @param item <#item description#>
 */
- (void)moveItem:(FFItem *)item {
    // 获取移动时的最开始的位置
    static NSInteger currentIndex = 0;

    // 让item的位置跟随拖拽的位置
    UIPanGestureRecognizer *panGesture = item.panGesture;
    [item.superview exchangeSubviewAtIndex:[item.superview.subviews indexOfObject:item] withSubviewAtIndex:[[item.superview subviews] count] - 1];
    CGPoint translation = [panGesture translationInView:panGesture.view];
    CGPoint center = panGesture.view.center;
    center.x += translation.x;
    center.y += translation.y;
    panGesture.view.center = center;
    [panGesture setTranslation:CGPointZero inView:panGesture.view];

    switch (panGesture.state) {
    case UIGestureRecognizerStateBegan: {
        for (NSInteger i = 0; i < self.topItemsArr.count; i++) {
            if (self.topItemsArr[i] == item) {
                currentIndex = i;
                break;
            }
        }

        // 放大item
        [UIView animateWithDuration:0.1
            animations:^{
                CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.2, 1.2);
                [item setTransform:newTRansform];
            }
            completion:^(BOOL finished){
            }];
    } break;
    case UIGestureRecognizerStateChanged: {
#warning 整理到此
        NSInteger indexX = (center.x <= wItemWidth + 2 * gEdgeGap) ? 0 : (center.x - wItemWidth - 2 * gEdgeGap) / (gEdgeGap + wItemWidth) + 1;
        NSInteger indexY = (center.y <= hItemHight + 2 * gEdgeGap) ? 0 : (center.y - hItemHight - 2 * gEdgeGap) / (gEdgeGap + hItemHight) + 1;

        NSInteger index = indexX + indexY * itemsPerLine;
        index = (index == 0) ? 1 : index;
        index = (index < self.topItemsArr.count) ? index : (self.topItemsArr.count - 1);
        [self.topItemsArr removeObject:item];
        [self.topItemsArr insertObject:item atIndex:index];

        for (NSInteger i = 0; i < self.topItemsArr.count; i++) {
            if ([self.topItemsArr objectAtIndex:i] != item) {
                FFItem *loacationItem = self.topItemsArr[i];
                [UIView animateWithDuration:0.3
                    delay:0
                    options:UIViewAnimationOptionLayoutSubviews
                    animations:^{
                        loacationItem.frame = CGRectMake(gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine), gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine), wItemWidth, hItemHight);
                    }
                    completion:^(BOOL finished){
                    }];
            }
        }
    } break;
    case UIGestureRecognizerStateEnded: {
        [UIView animateWithDuration:0.3
            animations:^{
                CGAffineTransform newTRansform = CGAffineTransformMakeScale(1.0, 1.0);
                [item setTransform:newTRansform];

                for (NSInteger i = 0; i < self.topItemsArr.count; i++) {
                    if ([self.topItemsArr objectAtIndex:i] == item) {
                        item.frame = CGRectMake(gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine), gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine), wItemWidth, hItemHight);

                        if (self.FFItemListOperationBlock) {
                            self.FFItemListOperationBlock(ItemOperationTypeMove, currentIndex, i);
                            break;
                        }
                    }
                }
            }
            completion:^(BOOL finished){

            }];
    }

    break;
    default:
        break;
    }
}

/**
 *  bottom部分点击
 *
 *  @param item <#item description#>
 */
- (void)bottomItemClick:(FFItem *)item {
    // items数组相应变化，及获取当前操作的item的位置
    __block NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.bottomItemsArr.count; i++) {
        if (self.bottomItemsArr[i] == item) {
            currentIndex = i;
            [self.bottomItemsArr removeObject:item];
            [self.topItemsArr addObject:item];
            break;
        }
    }

    // topView、bottomView的frame变化
    self.topViewHeight = gEdgeGap + (gEdgeGap + hItemHight) * ((self.topItemsArr.count - 1) / itemsPerLine + 1);
    self.bottomViewHeight = self.bottomItemsArr.count == 0 ? 0.0 : (gEdgeGap + (gEdgeGap + hItemHight) * ((self.bottomItemsArr.count - 1) / itemsPerLine + 1) + hArrowHeight);

    CGRect itemRect = item.frame;
    itemRect.origin.y += self.topViewHeight;
    item.frame = itemRect;
    [self.topView addSubview:item];

    // 内容视图的高度
    CGFloat contentSizeHight = self.isHiddenBottom ? self.topViewHeight : (self.topViewHeight + self.bottomViewHeight);
    self.contentSize = CGSizeMake(wMyScreenWidth, MAX(contentSizeHight, self.frame.size.height));

    // 如果bottom部分无item，隐藏提示View
    UIView *bottomHeaderView = [self.bottomView viewWithTag:999];
    bottomHeaderView.hidden = self.bottomItemsArr.count == 0 ? YES : NO;

    // 从bottom部分移除
    sWeakBlock(weakSelf);
    [UIView animateWithDuration:0.3
        delay:0
        options:UIViewAnimationOptionLayoutSubviews
        animations:^{
            [item removeFromSuperview];
            sStrongBlock(strongSelf);
            item.itemLocation = ItemLocationTop;
            CGFloat itemX = gEdgeGap + (gEdgeGap + wItemWidth) * ((strongSelf.topItemsArr.count - 1) % itemsPerLine);
            CGFloat itemY = gEdgeGap + (hItemHight + gEdgeGap) * ((strongSelf.topItemsArr.count - 1) / itemsPerLine);
            item.frame = CGRectMake(itemX, itemY, wItemWidth, hItemHight);
            [strongSelf.topView addSubview:item];

            UIView *bottomHeaderView = [strongSelf.bottomView viewWithTag:999];
            for (NSInteger i = 0; i < strongSelf.bottomItemsArr.count; i++) {
                FFItem *item = (FFItem *)strongSelf.bottomItemsArr[i];
                CGRect itemRect = item.frame;
                itemRect.origin.x = gEdgeGap + (gEdgeGap + wItemWidth) * (i % itemsPerLine);
                itemRect.origin.y = bottomHeaderView.frame.origin.y + bottomHeaderView.frame.size.height + gEdgeGap + (hItemHight + gEdgeGap) * (i / itemsPerLine);
                item.frame = itemRect;
            }

            CGRect topViewRect = strongSelf.topView.frame;
            topViewRect.size.height = strongSelf.topViewHeight;
            strongSelf.topView.frame = topViewRect;

            CGRect bottomViewRect = strongSelf.bottomView.frame;
            bottomViewRect.origin.y = strongSelf.topViewHeight;
            bottomViewRect.size.height = strongSelf.bottomViewHeight;
            strongSelf.bottomView.frame = bottomViewRect;
        }
        completion:^(BOOL finished) {
            sStrongBlock(strongSelf);

            if (strongSelf.FFItemListOperationBlock) {
                strongSelf.FFItemListOperationBlock(ItemOperationTypeBottomClick, currentIndex, currentIndex);
            }
        }];
}

@end
