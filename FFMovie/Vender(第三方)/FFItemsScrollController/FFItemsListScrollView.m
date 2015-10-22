//
//  FFItemsManageScrollView.m
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItemsListScrollView.h"

#define gGapFromEdge 20.0
#define itemsPerLine 4
#define wItemWidth (wScreenWidth - gGapFromEdge * (itemsPerLine + 1)) / itemsPerLine
#define hItemHight 25.0

@interface FFItemsListScrollView ()

/// 更多栏目头部
@property (nonatomic, strong) UIView *moreItemsHeaderView;
/// 所有的items
@property (nonatomic, strong) NSMutableArray *allItemsArr;
/// 被选中的item
@property (nonatomic, strong) UIButton *selectedItem;

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
        //        self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Set
- (void)setAllItemsNameArr:(NSMutableArray *)allItemsNameArr {
    _allItemsNameArr = allItemsNameArr;

    [self setUpMoreItemsHeaderViewWithTopItemsArr:allItemsNameArr[0]];
    [self setUpItemsWithallItemsNameArr:allItemsNameArr];
}


#pragma mark - SetUp
/**
 *  初始化更多栏目头部
 *
 *  @param topListItemsArr <#topListItemsArr description#>
 */
- (void)setUpMoreItemsHeaderViewWithTopItemsArr:(NSArray *)topItemsArr {
    if (!self.moreItemsHeaderView) {
        // 更多栏目头部
        CGFloat moreItemsHeaderViewY = gGapFromEdge + (gGapFromEdge + hItemHight) * ((topItemsArr.count - 1) / itemsPerLine + 1);
        self.moreItemsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, moreItemsHeaderViewY, wScreenWidth, 30.0)];
        self.moreItemsHeaderView.backgroundColor = [UIColor grayColor];
        UILabel *moreTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 100.0, self.moreItemsHeaderView.frame.size.height)];
        moreTextLabel.text = @"点击添加频道";
        moreTextLabel.font = [UIFont systemFontOfSize:14];
        [self.moreItemsHeaderView addSubview:moreTextLabel];
        [self addSubview:self.moreItemsHeaderView];
    }
}

/**
 *  初始化items
 *
 *  @param allItemsNameArr <#allItemsNameArr description#>
 */
- (void)setUpItemsWithallItemsNameArr:(NSArray *)allItemsNameArr {
    NSArray *topItemsArr = allItemsNameArr[0];
    NSArray *bottomItemsArr = allItemsNameArr[1];

    // 已添加items
    for (int i = 0; i < topItemsArr.count; i++) {
        CGFloat itemX = gGapFromEdge + (gGapFromEdge + wItemWidth) * (i % itemsPerLine);
        CGFloat itemY = gGapFromEdge + (hItemHight + gGapFromEdge) * (i / itemsPerLine);
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(itemX, itemY, wItemWidth, hItemHight)];
        itemButton.backgroundColor = [UIColor orangeColor];
        [itemButton setTitle:topItemsArr[i] forState:UIControlStateNormal];
        [self addSubview:itemButton];
        [self.allItemsArr addObject:itemButton];

        if (!self.selectedItem) {
            [itemButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.selectedItem = itemButton;
        }
    }

    // 更多items
    for (int i = 0; i < bottomItemsArr.count; i++) {
        CGFloat itemX = gGapFromEdge + (gGapFromEdge + wItemWidth) * (i % itemsPerLine);
        CGFloat itemY = self.moreItemsHeaderView.frame.origin.y + self.moreItemsHeaderView.frame.size.height + gGapFromEdge + (hItemHight + gGapFromEdge) * (i / itemsPerLine);
        UIButton *itemButton = [[UIButton alloc] initWithFrame:CGRectMake(itemX, itemY, wItemWidth, hItemHight)];
        itemButton.backgroundColor = [UIColor grayColor];
        [itemButton setTitle:bottomItemsArr[i] forState:UIControlStateNormal];
        [self addSubview:itemButton];
        [self.allItemsArr addObject:itemButton];
    }

    CGFloat contentSizeHight = self.moreItemsHeaderView.frame.origin.y + self.moreItemsHeaderView.frame.size.height + gGapFromEdge + (hItemHight + gGapFromEdge) * ((bottomItemsArr.count - 1) / itemsPerLine + 1);
    self.contentSize = CGSizeMake(wScreenWidth, contentSizeHight);
}


#pragma mark--
- (void)itemRespondFromListBarClickWithItemName:(NSString *)itemName {
    for (int i = 0; i < self.allItemsArr.count; i++) {
        //        BYListItem *item = (BYListItem *)self.allItemsArr[i];
        //        if ([itemName isEqualToString:item.itemName]) {
        //            [self.selectedItem setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
        //            [item setTitleColor:[UIColor redColor] forState:0];
        //            self.selectedItem = item;
        //        }
    }
}

- (NSMutableArray *)allItemsArr {
    if (_allItemsArr == nil) {
        _allItemsArr = [NSMutableArray array];
    }
    return _allItemsArr;
}

- (NSMutableArray *)topView {
    if (_topView == nil) {
        _topView = [NSMutableArray array];
    }
    return _topView;
}

- (NSMutableArray *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [NSMutableArray array];
    }
    return _bottomView;
}


@end
