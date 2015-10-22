//
//  MovieViewController.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "MovieViewController.h"

@interface MovieViewController ()

@end

@implementation MovieViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"电影";
    
    self.allItemsNameArr = [[NSMutableArray alloc] initWithObjects:@[@"推荐", @"热点", @"杭州", @"社会", @"娱乐", @"科技", @"汽车", @"体育", @"订阅", @"财经", @"军事", @"国际", @"正能量", @"段子", @"趣图", @"美女", @"健康", @"教育", @"特卖", @"彩票", @"辟谣"], @[@"电影",@"数码",@"时尚",@"奇葩",@"游戏",@"旅游",@"育儿",@"减肥",@"养生",@"美食",@"政务",@"历史",@"探索",@"故事",@"美文",@"情感",@"语录",@"美图",@"房产",@"家居",@"搞笑",@"星座",@"文化",@"毕业生",@"视频",@"搞笑",@"星座",@"文化",@"毕业生",@"视频",@"搞笑",@"星座",@"文化",@"毕业生",@"视频",@"搞笑",@"星座",@"文化",@"毕业生",@"视频"], nil];
}

@end
