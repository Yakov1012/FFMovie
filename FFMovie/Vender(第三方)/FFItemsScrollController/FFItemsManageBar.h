//
//  FFItemsManageBar.h
//  FFMovie
//
//  Created by Yakov on 15/10/22.
//  Copyright © 2015年 Yakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFItemsMacro.h"

@interface FFItemsManageBar : UIView

/// 管理按钮点击
@property (nonatomic, copy) void (^manageButtonClick)(BOOL isDone);

@end
