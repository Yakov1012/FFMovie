//
//  RootViewController.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFTabBarController.h"

#import "FFNavigationController.h"
#import "MovieViewController.h"
#import "NewsViewController.h"
#import "Top250ViewController.h"
#import "CinemaViewController.h"
#import "MoreViewController.h"

@interface FFTabBarController ()

@end

@implementation FFTabBarController

#pragma mark - LifeCycle
/**
 *  释放
 */
- (void)dealloc {
    // 移除更换皮肤的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nSkinDidChangeNotification object:nil];
}

/**
 *  加载视图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    // 状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // 监听更换皮肤的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinDidChangeNotification:) name:nSkinDidChangeNotification object:nil];

    // 安装viewControllers
    [self setUpViewControllers];

    // 加载皮肤
    [self loadSkin];
}


#pragma mark - SetUp
/**
 *  安装viewControllers
 */
- (void)setUpViewControllers {
    // 电影
    MovieViewController *movieVC = [[MovieViewController alloc] init];
    FFNavigationController *movieNav = [[FFNavigationController alloc] initWithRootViewController:movieVC];

    // 新闻
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    FFNavigationController *newsNav = [[FFNavigationController alloc] initWithRootViewController:newsVC];

    // Top250
    Top250ViewController *top250VC = [[Top250ViewController alloc] init];
    FFNavigationController *top250Nav = [[FFNavigationController alloc] initWithRootViewController:top250VC];

    // 影院
    CinemaViewController *cinemaVC = [[CinemaViewController alloc] init];
    FFNavigationController *cinemaNav = [[FFNavigationController alloc] initWithRootViewController:cinemaVC];

    // 更多
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    FFNavigationController *moreNav = [[FFNavigationController alloc] initWithRootViewController:moreVC];

    self.viewControllers = @[movieNav, newsNav, top250Nav, cinemaNav, moreNav];
}

/**
 *  初始化TabBar
 */
- (void)setUpTabBar {
    // 背景
    UIImage *tabBarBackgroundImage = [[FFSkinUtils shareInstance] getImageWithNameBySkin:@"Root/TabBar_Background" resizable:YES];
    self.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarBackgroundImage];

    // 文字、图标 数组
    NSArray *itemTitleArr = @[@"电影", @"新闻", @"Top250", @"影院", @"更多"];
    NSArray *itemImageNameArr = @[@"Home", @"Board", @"Found", @"Message", @"My"];

    // items数组
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger index = 0; index < itemTitleArr.count; index++) {
        NSString *title = itemTitleArr[index];
        UIImage *normalimage = [[FFSkinUtils shareInstance] getImageWithNameBySkin:[NSString stringWithFormat:@"Root/%@_Normal", itemImageNameArr[index]]];
        UIImage *selectedImage = [[FFSkinUtils shareInstance] getImageWithNameBySkin:[NSString stringWithFormat:@"Root/%@_Highlighted", itemImageNameArr[index]]];

        [items addObject:@{ @"Title": title, @"Image": normalimage, @"SelectedImage": selectedImage }];
    }

    // 设置tabBarItem
    [self setUpTabBarItem:items translucent:YES];

    // 字体
    UIFont *font = [UIFont systemFontOfSize:12.0];
    self.normalFont = font;
    self.selectedFont = font;

    // 颜色
    UIColor *normalColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"TabBarItem_Normal_Color"];
    self.normalColor = normalColor;
    UIColor *selectedColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"TabBarItem_Highlighted_Color"];
    [self setSelectedColor:selectedColor];
    
    // 设置小红点
    [self setUpBadgeValue:0];
    [self setUpBadgeValue:1 badgeValue:@"新消息"];
    [self setUpBadgeValue:2 badgeValue:@"99"];
}


#pragma mark - Action
/**
 *  加载皮肤
 */
- (void)loadSkin {
    [self setUpTabBar];
}


#pragma mark - Notification
- (void)skinDidChangeNotification:(NSNotification *)notification {
    [self loadSkin];
}

@end
