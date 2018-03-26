//
//  XYPHBindAccountController.m
//  FormView
//
//  Created by xiAo_Ju on 23/03/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHBindAccountController.h"

#import "BindAccountTitleCell.h"
#import "UserCardCell.h"


@interface XYPHBindAccountController ()

@end

@implementation XYPHBindAccountController

- (void)initSubviews {
    // 去掉顶部sectionHeader
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    UserCardCellItem *cardItem = [UserCardCellItem new];
    cardItem.isBinding = YES;
    
    BindAccountTitleCellItem *user1Item = [BindAccountTitleCellItem new];
    user1Item.title = @"你的手机号+86 18369956251 已被下方账号绑定";
    
    BindAccountTitleCellItem *user2Item = [BindAccountTitleCellItem new];
    user2Item.title = @"是否换绑至当前登录的账号";
    
    UserCardCellItem *card1Item = [UserCardCellItem new];

    self.form = @[
                  @[
                      [[Row alloc] initWithClass:[BindAccountTitleCell class] model:user1Item],
                      [[Row alloc] initWithClass:[UserCardCell class] model:cardItem],
                      [[Row alloc] initWithClass:[BindAccountTitleCell class] model:user2Item],
                      [[Row alloc] initWithClass:[UserCardCell class] model:card1Item]
                      ]
                  ];
}

@end