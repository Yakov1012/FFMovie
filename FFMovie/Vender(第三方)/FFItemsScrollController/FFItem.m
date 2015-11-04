//
//  FFItem.m
//  FFMovie
//
//  Created by Yakov on 15/10/23.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import "FFItem.h"

@interface FFItem ()

/// 左上角的删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation FFItem

#pragma mark - LifeCycle
/**
 *  Description
 */
- (void)dealloc {
    [self.deleteBtn removeFromSuperview];
    self.deleteBtn = nil;

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nManagerNotification object:nil];
}

/**
 *  <#Description#>
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor grayColor] forState:0];
        self.titleLabel.font = [UIFont systemFontOfSize:sItemFontSize];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        [self addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];

        // 排序通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managerNotification:) name:nManagerNotification object:nil];
    }

    return self;
}

/**
 *  解决deleteBtn超出部分不响应
 *
 *  @param point <#point description#>
 *  @param event <#event description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isInside = [super pointInside:point withEvent:event];

    CGPoint inButtonSpace = [self convertPoint:point toView:self.deleteBtn];

    BOOL isInsideButton = [self.deleteBtn pointInside:inButtonSpace withEvent:nil];

    if (isInsideButton) {
        return isInsideButton;
    }

    return isInside;
}


#pragma mark - Set
/**
 *  item名字
 *
 *  @param itemName <#itemName description#>
 */
- (void)setItemName:(NSString *)itemName {
    _itemName = itemName;

    [self setTitle:itemName forState:UIControlStateNormal];
}

/**
 *  item位置，top or bottom
 *
 *  @param itemLocation <#itemLocation description#>
 */
- (void)setItemLocation:(ItemLocation)itemLocation {
    _itemLocation = itemLocation;

    if (itemLocation == ItemLocationTop) {
        [self setUpDeleteBtn];
        [self setUpPanGesture];
    } else {
        [self.deleteBtn removeFromSuperview];
        self.deleteBtn = nil;
        [self removeGestureRecognizer:self.panGesture];
        self.panGesture = nil;
    }
}


#pragma mark - SetUp
/**
 *  添加删除按钮
 */
- (void)setUpDeleteBtn {
    if ([self.itemName isEqualToString:@"推荐"]) {
        return;
    }

    if (!self.deleteBtn) {
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(-20.0 / 5.0, -20.0 / 5.0, 20.0, 20.0)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
        self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width / 2.0;
        self.deleteBtn.hidden = YES;
        self.deleteBtn.backgroundColor = [UIColor grayColor];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
}

/**
 *  添加长按手势
 */
- (void)setUpPanGesture {
    if ([self.itemName isEqualToString:@"推荐"]) {
        return;
    }

    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        self.panGesture.enabled = NO;
        [self addGestureRecognizer:self.panGesture];
    }
}


#pragma mark - Action
/**
 *  item点击
 *
 *  @param button <#button description#>
 */
- (void)itemClick:(UIButton *)button {
    if (self.itemLocation == ItemLocationTop) {
        if (self.FFItemOperationBlock) {
            self.FFItemOperationBlock(ItemOperationTypeTopClick, self);
        }
    } else if (self.itemLocation == ItemLocationBottom) {
        if (self.FFItemOperationBlock) {
            self.FFItemOperationBlock(ItemOperationTypeBottomClick, self);
        }
    }
}

/**
 *  删除
 *
 *  @param button <#button description#>
 */
- (void)deleteBtnClcik:(UIButton *)button {
    if (self.FFItemOperationBlock) {
        self.FFItemOperationBlock(ItemOperationTypeDelete, self);
    }
}

/**
 *  长按
 *
 *  @param gesture <#gesture description#>
 */
- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (self.FFItemOperationBlock) {
        self.FFItemOperationBlock(ItemOperationTypeMove, self);
    }
}


#pragma mark - ManagerNotification
/**
 *  接收排序通知
 *
 *  @param notification <#notification description#>
 */
- (void)managerNotification:(NSNotification *)notification {
    BOOL hiddenDeleteBtn = [[notification object] boolValue];
    self.deleteBtn.hidden = hiddenDeleteBtn;

    self.panGesture.enabled = !self.deleteBtn.hidden;
}

@end
