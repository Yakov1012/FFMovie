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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nManagerNotification object:nil];
}

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


#pragma mark - Set
- (void)setItemName:(NSString *)itemName {
    _itemName = itemName;

    [self setTitle:itemName forState:UIControlStateNormal];
}

- (void)setItemLocation:(ItemLocation)itemLocation {
    _itemLocation = itemLocation;

    if (itemLocation == ItemLocationTop) {
        [self setUpDeleteBtn];
        [self setUpPanGesture];
    } else {
        [self.deleteBtn removeFromSuperview];
        [self removeGestureRecognizer:self.panGesture];
    }
}


#pragma mark - SetUp
- (void)setUpDeleteBtn {
    if (!self.deleteBtn) {
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(-12.0 / 5.0, -12.0 / 5.0, 12.0, 12.0)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"Delete"] forState:UIControlStateNormal];
        self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width / 2.0;
        self.deleteBtn.hidden = YES;
        self.deleteBtn.backgroundColor = [UIColor grayColor];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
}

- (void)setUpPanGesture {
    if (!self.panGesture) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:self.panGesture];
    }
}


#pragma mark - Action
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

- (void)deleteBtnClcik:(UIButton *)button {
    if (self.FFItemOperationBlock) {
        self.FFItemOperationBlock(ItemOperationTypeDelete, self);
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (self.FFItemOperationBlock) {
        self.FFItemOperationBlock(ItemOperationTypeMove, self);
    }
}


#pragma mark - ManagerNotification
- (void)managerNotification:(NSNotification *)notification {
    BOOL hiddenDeleteBtn = [[notification object] boolValue];
    self.deleteBtn.hidden = hiddenDeleteBtn;
    
    self.panGesture.enabled = !self.deleteBtn.hidden;
}

@end
