//
//  FFHorizontalScrollController.m
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItemsScrollController.h"

#import "FFItemsScrollBar.h"
#import "FFItemsManageBar.h"
#import "FFItemsListScrollView.h"

@interface FFItemsScrollController () <UIScrollViewDelegate>

/// 展开、收起按钮
@property (strong, nonatomic) UIButton *arrowButton;
/// 横向滚动条
@property (strong, nonatomic) FFItemsScrollBar *itemsScrollBar;
/// 管理条
@property (strong, nonatomic) FFItemsManageBar *itemsManageBar;
/// 所有items列表视图
@property (strong, nonatomic) FFItemsListScrollView *itemsListScrollView;
/// 底部主滑动视图
@property (strong, nonatomic) UIScrollView *mainScrollView;
/// 底部主滑动视图上的控制器数组
@property (strong, nonatomic) NSMutableArray *vcArr;

@end

@implementation FFItemsScrollController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.vcArr = [NSMutableArray arrayWithCapacity:1];
}


#pragma mark - Set
- (void)setAllItemsNameArr:(NSMutableArray *)allItemsNameArr {
    _allItemsNameArr = allItemsNameArr;

    [self setUpArrowButton];
    [self setUpItemsScrollBar];
    [self setUpItemsManageBar];
    [self setUpItemsListScrollView];
    [self setUpMainScrollView];
}

#pragma mark - SetUp
/**
 *  展开、收起按钮
 */
- (void)setUpArrowButton {
    if (!self.arrowButton) {
        self.arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(wScreenWidth - wArrowWidth, 0, wArrowWidth, hArrowHeight)];
        [self.arrowButton setImage:[UIImage imageNamed:@"Arrow.png"] forState:UIControlStateNormal];
        [self.arrowButton addTarget:self action:@selector(arrowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.arrowButton];
    }
}

/**
 *  初始化横向滚动条
 */
- (void)setUpItemsScrollBar {
    if (!self.itemsScrollBar) {
        self.itemsScrollBar = [[FFItemsScrollBar alloc] initWithFrame:CGRectMake(0.0, 0.0, wScreenWidth - wArrowWidth, hArrowHeight)];
        self.itemsScrollBar.itemsNameArr = [NSMutableArray arrayWithArray:self.allItemsNameArr[0]];
        sWeakBlock(weakSelf);
        self.itemsScrollBar.itemClickBlock = ^(NSString *itemName, NSInteger itemIndex) {
            // 移动到该位置
            sStrongBlock(strongSelf);
            strongSelf.mainScrollView.contentOffset = CGPointMake(itemIndex * strongSelf.mainScrollView.frame.size.width, 0);
        };
        [self.view addSubview:self.itemsScrollBar];
    }
}

/**
 *  初始化管理条
 */
- (void)setUpItemsManageBar {
    if (!self.itemsManageBar) {
        self.itemsManageBar = [[FFItemsManageBar alloc] initWithFrame:CGRectMake(0.0, 0.0, wScreenWidth - wArrowWidth, hArrowHeight)];
        self.itemsManageBar.hidden = YES;
        sWeakBlock(weakSelf);
        self.itemsManageBar.manageButtonClick = ^(BOOL isDone) {
            sStrongBlock(strongSelf);
            strongSelf.itemsListScrollView.isHiddenBottom = isDone;
        };
        [self.view addSubview:self.itemsManageBar];
    }
}

/**
 *  初始化所有items列表视图
 */
- (void)setUpItemsListScrollView {
    if (!self.itemsListScrollView) {

        self.itemsListScrollView = [[FFItemsListScrollView alloc] initWithFrame:CGRectMake(0.0, 64.0 + hArrowHeight, wScreenWidth, 0.0)];
        self.itemsListScrollView.allItemsNameArr = [NSMutableArray arrayWithArray:self.allItemsNameArr];
        sWeakBlock(weakSelf);
        sStrongBlock(strongSelf);
        self.itemsListScrollView.FFItemListOperationBlock = ^(ItemOperationType itemOperationType, NSInteger currentIndex, NSInteger toIndex) {
            if (itemOperationType == ItemOperationTypeTopClick) { // top部分点击
                strongSelf.itemsScrollBar.hidden = NO;
                strongSelf.itemsManageBar.hidden = YES;
                strongSelf.itemsListScrollView.isHiddenBottom = NO;

                [UIView animateWithDuration:.5
                                 animations:^{
                                     CGRect itemsListScrollViewRect = strongSelf.itemsListScrollView.frame;
                                     itemsListScrollViewRect.size.height = 0.0;
                                     strongSelf.itemsListScrollView.frame = itemsListScrollViewRect;

                                     CGAffineTransform rotation = strongSelf.arrowButton.imageView.transform;
                                     strongSelf.arrowButton.imageView.transform = CGAffineTransformRotate(rotation, M_PI);
                                 }];

                // 移动itemsScrollBar的item
                [strongSelf.itemsScrollBar itemScrollToIndex:currentIndex];
            }

            else if (itemOperationType == ItemOperationTypeDelete) { // top部分删除
                NSMutableArray *topItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[0]];
                NSMutableArray *bottomItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[1]];

                // itemsScrollBar移除相应item
                NSString *itemName = topItemsNameArr[currentIndex];
                [strongSelf.itemsScrollBar deleteItem:currentIndex];

                // 重新构建allItemsNameArr
                [topItemsNameArr removeObjectAtIndex:currentIndex];
                [bottomItemsNameArr insertObject:itemName atIndex:0];
                strongSelf.allItemsNameArr = [NSMutableArray arrayWithObjects:topItemsNameArr, bottomItemsNameArr, nil];

                // 删除viewController
                [strongSelf deleteViewController:currentIndex];
            }

            else if (itemOperationType == ItemOperationTypeMove) { // top部分移动
                NSMutableArray *topItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[0]];
                NSMutableArray *bottomItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[1]];
                NSObject *topItemName = topItemsNameArr[currentIndex];
                [topItemsNameArr removeObjectAtIndex:currentIndex];
                [topItemsNameArr insertObject:topItemName atIndex:toIndex];
                strongSelf.allItemsNameArr = [NSMutableArray arrayWithObjects:topItemsNameArr, bottomItemsNameArr, nil];

                // itemsScrollBar相应item移动
                [strongSelf.itemsScrollBar moveItem:currentIndex toIndex:toIndex];

                // 移动viewController
                [strongSelf moveViewController:currentIndex toIndex:toIndex];
            }

            else if (itemOperationType == ItemOperationTypeBottomClick) { // bottom部分点击
                NSMutableArray *topItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[0]];
                NSMutableArray *bottomItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[1]];

                NSString *itemName = bottomItemsNameArr[currentIndex];
                [strongSelf.itemsScrollBar addItem:itemName];

                [bottomItemsNameArr removeObjectAtIndex:currentIndex];
                [topItemsNameArr addObject:itemName];

                strongSelf.allItemsNameArr = [NSMutableArray arrayWithObjects:topItemsNameArr, bottomItemsNameArr, nil];

                // 添加控制器
                [strongSelf addViewToMainScrollViewWithItemName:itemName index:strongSelf.vcArr.count];
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:self.itemsListScrollView];
    }
}

/**
 *  初始化底部主滑动视图
 */
- (void)setUpMainScrollView {
    if (!self.mainScrollView) {
        CGFloat mainScrollViewH = hScreenHeight - (hArrowHeight + 64.0 + self.tabBarController.tabBar.frame.size.height);
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, hArrowHeight, wScreenWidth, mainScrollViewH)];
        self.mainScrollView.backgroundColor = [UIColor yellowColor];
        self.mainScrollView.bounces = NO;
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        self.mainScrollView.delegate = self;
        NSArray *topItemsNameArr = self.allItemsNameArr[0];
        self.mainScrollView.contentSize = CGSizeMake(wScreenWidth * topItemsNameArr.count, self.mainScrollView.frame.size.height);
        [self.view insertSubview:self.mainScrollView atIndex:0];

        for (NSInteger i = 0; i < topItemsNameArr.count; i++) {
            [self addViewToMainScrollViewWithItemName:topItemsNameArr[i] index:i];
        }
    }
}


#pragma mark - Action
/**
 *  <#Description#>
 *
 *  @param button <#button description#>
 */
- (void)arrowButtonClick:(UIButton *)button {
    self.itemsScrollBar.hidden = !self.itemsScrollBar.hidden;
    self.itemsManageBar.hidden = !self.itemsManageBar.hidden;
    self.itemsListScrollView.isHiddenBottom = NO;

    // 发通知，隐藏删除按钮
    [[NSNotificationCenter defaultCenter] postNotificationName:nManagerNotification object:@(!self.itemsListScrollView.isHiddenBottom)];

    CGFloat itemsListScrollViewH = hScreenHeight - (self.itemsScrollBar.frame.origin.y + self.itemsScrollBar.frame.size.height + 64.0);
    sWeakBlock(weakSelf);
    [UIView animateWithDuration:.5
                     animations:^{
                         sStrongBlock(strongSelf);
                         CGRect itemsListScrollViewRect = strongSelf.itemsListScrollView.frame;
                         if (strongSelf.itemsScrollBar.hidden) {
                             itemsListScrollViewRect.size.height = itemsListScrollViewH;
                         } else {
                             itemsListScrollViewRect.size.height = 0.0;
                         }
                         strongSelf.itemsListScrollView.frame = itemsListScrollViewRect;

                         CGAffineTransform rotation = button.imageView.transform;
                         button.imageView.transform = CGAffineTransformRotate(rotation, M_PI);
                     }];
}

/**
 *  添加viewController
 *
 *  @param itemName <#itemName description#>
 *  @param index    <#index description#>
 */
- (void)addViewToMainScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.frame = CGRectMake(index * self.mainScrollView.frame.size.width, 0.0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    viewController.view.backgroundColor = index % 2 == 0 ? [UIColor redColor] : [UIColor orangeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 20.0)];
    label.text = [NSString stringWithFormat:@"%@", itemName];
    [viewController.view addSubview:label];
    [self.mainScrollView addSubview:viewController.view];
    [self.vcArr addObject:viewController];

    self.mainScrollView.contentSize = self.mainScrollView.contentSize = CGSizeMake(wScreenWidth * self.vcArr.count, self.mainScrollView.frame.size.height);
    ;
}

/**
 *  移除viewController
 *
 *  @param index <#index description#>
 */
- (void)deleteViewController:(NSInteger)index {
    UIViewController *viewController = self.vcArr[index];
    [viewController.view removeFromSuperview];
    [self.vcArr removeObjectAtIndex:index];

    for (NSInteger i = index; i < self.vcArr.count; i++) {
        UIViewController *viewController = self.vcArr[i];
        CGRect vcRect = viewController.view.frame;
        vcRect.origin.x -= self.mainScrollView.frame.size.width;
        viewController.view.frame = vcRect;
    }

    CGSize contentSize = self.mainScrollView.contentSize;
    contentSize.width -= self.mainScrollView.frame.size.width;
    self.mainScrollView.contentSize = contentSize;

    self.mainScrollView.contentOffset = CGPointMake(self.itemsScrollBar.selectedIndex * self.mainScrollView.frame.size.width, 0);
}

/**
 *  移动viewController
 *
 *  @param currentIndex <#currentIndex description#>
 *  @param toIndex      <#toIndex description#>
 */
- (void)moveViewController:(NSInteger)currentIndex toIndex:(NSInteger)toIndex {
    // 起点
    NSInteger startPoint;
    // 终点
    NSInteger endPoint;
    if (currentIndex <= toIndex) {
        startPoint = currentIndex;
        endPoint = toIndex;

    } else {
        startPoint = toIndex;
        endPoint = currentIndex;
    }
    // 开始的vc
    UIViewController *starVC = self.vcArr[startPoint];

    // vc数组
    NSObject *currentVC = self.vcArr[currentIndex];
    [self.vcArr removeObjectAtIndex:currentIndex];
    [self.vcArr insertObject:currentVC atIndex:toIndex];

    CGRect vcRect = starVC.view.frame;
    for (NSInteger i = startPoint; i <= endPoint; i++) {
        UIViewController *viewController = self.vcArr[i];
        viewController.view.frame = vcRect;
        vcRect.origin.x += viewController.view.frame.size.width;
    }

    self.mainScrollView.contentOffset = CGPointMake(self.itemsScrollBar.selectedIndex * self.mainScrollView.frame.size.width, 0);
}


#pragma mark - UIScrollViewDelegate
/**
 *  <#Description#>
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger itemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.itemsScrollBar itemScrollToIndex:itemIndex];
}

@end
