//
//  MovieViewController.m
//  FFMovie
//
//  Created by Yakov on 15/10/19.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "MovieViewController.h"

#import "FFUserDefaultsUtils.h"

@interface MovieViewController ()

@end

@implementation MovieViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"电影";

    UIButton *skinButton = [[UIButton alloc] initWithFrame:CGRectMake((wScreenWidth - 100.0) / 2.0, (hScreenHeight - 100.0) / 2.0, 100.0, 100.0)];
    skinButton.backgroundColor = [UIColor orangeColor];
    [skinButton addTarget:self action:@selector(skinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skinButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
- (void)skinButtonClick:(UIButton *)button {
    if ([FFSkinUtils shareInstance].skinType == SkinTypeDay) {
        [FFSkinUtils shareInstance].skinName = @"SkinNight";
        [FFUserDefaultsUtils setUserDefaults:kSkinName value:@"SkinNight"];
    } else if ([FFSkinUtils shareInstance].skinType == SkinTypeNight) {
        [FFSkinUtils shareInstance].skinName = @"SkinDay";
        [FFUserDefaultsUtils setUserDefaults:kSkinName value:@"SkinDay"];
    } else {
        [FFSkinUtils shareInstance].skinName = @"SkinNight";
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:nSkinDidChangeNotification object:nil];
}

@end
