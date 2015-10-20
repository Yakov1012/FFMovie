//
//  FFNavigationController.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFNavigationController.h"

#import "FFImageUtils.h"

@interface FFNavigationController ()

@end

@implementation FFNavigationController

#pragma mark - LifeCycle
/**
 *  释放
 */
- (void)dealloc {
    // 移除更换皮肤的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nSkinDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 隐藏横线
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];

    // 监听更换皮肤的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinDidChangeNotification:) name:nSkinDidChangeNotification object:nil];

    // 加载皮肤
    [self loadSkin];
}


#pragma mark - SetUp
- (void)setUpNavigationBar {
    // 导航栏背景
    UIColor *backgroundColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"Nav_Background_Color"];
    UIImage *backgroundImage = [FFImageUtils getImageWithColor:backgroundColor size:CGSizeMake(self.navigationBar.frame.size.width, 64.0)];
    [self.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // 标题颜色
    UIColor *titleColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"Nav_Title_Color"];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor};
    
    // TintColor
    UIColor *tintColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"Nav_Tint_Color"];
    self.navigationBar.tintColor = tintColor;
}


#pragma mark - Action
/**
 *  加载皮肤
 */
- (void)loadSkin {
    [self setUpNavigationBar];
}


#pragma mark - Notification
- (void)skinDidChangeNotification:(NSNotification *)notification {
    [self loadSkin];
}

@end
