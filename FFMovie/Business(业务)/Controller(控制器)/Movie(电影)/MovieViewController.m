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
    
    self.allItemsNameArr = [[NSMutableArray alloc] initWithObjects:@[@"推荐", @"奔跑吧兄弟", @"快乐大本营", @"天天向上",@"NBA",@"CBA", @"非诚勿扰", @"电视剧", @"电影", @"综艺", @"动漫", @"资讯", @"娱乐", @"搞笑", @"少儿", @"原创"], @[@"体育",@"风云榜",@"全网影视",@"直播中心",@"片花",@"脱口秀",@"微电影",@"纪录片",@"排行版",@"韩剧",@"枚举",@"历史",@"探索",@"汽车",@"时尚",@"生活",@"旅游",@"音乐",@"财经"], nil];
}

@end
