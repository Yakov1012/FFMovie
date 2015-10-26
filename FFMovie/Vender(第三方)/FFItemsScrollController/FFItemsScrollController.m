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
        self.itemsListScrollView.operationBlock = ^(ItemOperationType itemOperationType, NSString *itemName) {
            if (itemOperationType == ItemOperationTypeBottomClick) {
                sStrongBlock(strongSelf);
                [strongSelf.itemsScrollBar addItem:itemName];
            } else if (itemOperationType == ItemOperationTypeDelete) {
                sStrongBlock(strongSelf);
                [strongSelf.itemsScrollBar deleteItem:itemName];
                
                NSMutableArray *topItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[0]];
                NSMutableArray *bottomItemsNameArr = [NSMutableArray arrayWithArray:strongSelf.allItemsNameArr[1]];
                static NSInteger deleteItemLocation;
                for (NSInteger i = 0; i < topItemsNameArr.count; i ++) {
                    if ([itemName isEqualToString:topItemsNameArr[i]]) {
                        [topItemsNameArr removeObjectAtIndex:i];
                        [bottomItemsNameArr addObject:itemName];
                        strongSelf.allItemsNameArr = [NSMutableArray arrayWithObjects:topItemsNameArr, bottomItemsNameArr, nil];
                        deleteItemLocation = i;
                        break;
                    }
                }
                [strongSelf deletViewController:deleteItemLocation];
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
- (void)arrowButtonClick:(UIButton *)button {
    self.itemsScrollBar.hidden = !self.itemsScrollBar.hidden;
    self.itemsManageBar.hidden = !self.itemsManageBar.hidden;
    self.itemsListScrollView.isHiddenBottom = NO;

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

- (void)addViewToMainScrollViewWithItemName:(NSString *)itemName index:(NSInteger)index {
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.frame = CGRectMake(index * self.mainScrollView.frame.size.width, 0.0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
    viewController.view.backgroundColor = index % 2 == 0 ? [UIColor redColor] : [UIColor orangeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 60.0, 20.0)];
    label.text = [NSString stringWithFormat:@"%@", itemName];
    [viewController.view addSubview:label];
    [self.mainScrollView addSubview:viewController.view];
    
    [self.vcArr addObject:viewController];
}

- (void)deletViewController:(NSInteger)index {
    UIViewController *viewController = self.vcArr[index];
    [viewController.view removeFromSuperview];
    [self.vcArr removeObjectAtIndex:index];
    
    for (NSInteger i = index; i < self.vcArr.count; i ++) {
        UIViewController *viewController = self.vcArr[i];
        CGRect vcRect = viewController.view.frame;
        vcRect.origin.x -= self.mainScrollView.frame.size.width;
        viewController.view.frame = vcRect;
    }
    
    CGSize contentSize = self.mainScrollView.contentSize;
    contentSize.width -= self.mainScrollView.frame.size.width;
    self.mainScrollView.contentSize = contentSize;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger itemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.itemsScrollBar itemScrollToIndex:itemIndex];
}

@end
