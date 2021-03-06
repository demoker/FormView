//
//  AccountTitleCell.h
//  FormView
//
//  Created by 黄伯驹 on 2017/12/4.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRow.h"

@interface AccountXYPHBindAccountTitleCellItem : NSObject

@property(nonatomic, copy)  NSString *text;

@end

@interface AccountTitleCell : UITableViewCell <XYUpdatable>

@end
