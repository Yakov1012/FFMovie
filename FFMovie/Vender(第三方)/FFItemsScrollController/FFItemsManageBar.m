//
//  FFItemsManageBar.m
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItemsManageBar.h"

@interface FFItemsManageBar ()

/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  管理按钮(排序、完成)
 */
@property (strong, nonatomic) UIButton *manageButton;

@end

@implementation FFItemsManageBar

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpTitleLabel];
        [self setUpManageButton];
    }
    return self;
}


#pragma mark - SetUp
/**
 *  初始化标题
 */
- (void)setUpTitleLabel {
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, self.frame.size.height)];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        self.titleLabel.text = @"切换栏目";
        self.titleLabel.textColor = [UIColor grayColor];
        [self addSubview:self.titleLabel];
    }
}

/**
 *  初始化管理按钮
 */
- (void)setUpManageButton {
    if (!self.manageButton) {
        self.manageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50.0, 5.0, 50.0, self.frame.size.height - 2 * 5.0)];
        [self.manageButton setTitle:@"排序" forState:0];
        [self.manageButton setTitleColor:[UIColor redColor] forState:0];
        self.manageButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.manageButton.layer.cornerRadius = 5;
        self.manageButton.layer.borderWidth = 0.5;
        [self.manageButton.layer setMasksToBounds:YES];
        self.manageButton.layer.borderColor = [[UIColor redColor] CGColor];
        [self.manageButton addTarget:self action:@selector(manageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.manageButton];
    }
}


#pragma mark - Action
- (void)manageButtonClick:(UIButton *)button {
    if (button.selected) {
        [button setTitle:@"排序" forState:UIControlStateNormal];
        self.titleLabel.text = @"切换栏目";
    } else {
        [button setTitle:@"完成" forState:UIControlStateNormal];
        self.titleLabel.text = @"拖拽可以排序";
    }

    button.selected = !button.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sortBtnClick" object:button userInfo:nil];
}

@end
