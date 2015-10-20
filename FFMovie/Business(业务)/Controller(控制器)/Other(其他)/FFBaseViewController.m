//
//  FFBaseViewController.m
//
//
//  Created by Yakov on 15/10/16.
//
//

#import "FFBaseViewController.h"

@implementation FFBaseViewController

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

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 监听更换皮肤的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinDidChangeNotification:) name:nSkinDidChangeNotification object:nil];

    // 加载皮肤
    [self loadSkin];
}

#pragma mark - SetUp
/**
 *  设置背景颜色
 */
- (void)setUpBackgroudColor {
    UIColor *backgroundColor = [[FFSkinUtils shareInstance] getColorWithNameBySkin:@"View_Background_Color"];
    self.view.backgroundColor = backgroundColor;
}

#pragma mark - Action
/**
 *  加载皮肤
 */
- (void)loadSkin {
    [self setUpBackgroudColor];
}

#pragma mark - Notification
- (void)skinDidChangeNotification:(NSNotification *)notification {
    [self loadSkin];
}

@end
