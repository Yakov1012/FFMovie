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
}

/**
 *  加载视图
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //状态栏样式
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 背景图片
    UIImage *tabBarBackgroundImage = [FFImageUtils getImageWithNameByPath:@"TabBarBackground" resizable:YES];
    self.tabBar.barTintColor = [UIColor colorWithPatternImage:tabBarBackgroundImage];

    // 安装viewControllers
    [self setUpViewControllers];
}


#pragma mark - SetUp
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

@end
