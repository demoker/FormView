//
//  XYPHBindAccountUserCardView.m
//  FormView
//
//  Created by xiAo_Ju on 27/03/2018.
//  Copyright © 2018 黄伯驹. All rights reserved.
//

#import "XYPHBindAccountUserCardView.h"

#import "ImageTextView.h"

#import <Masonry.h>

#import "XYPHBindAccountUserCardCellItem.h"

#import "XYPHBindAccountBindStatusView.h"

@interface XYPHBindAccountUserCardView()

@property (nonatomic, strong, readwrite) UIView *wrapperView;

@property (nonatomic, strong) UIImageView *avatarView;

@property (nonatomic, strong) UILabel *bindStatusLabel;

@property (nonatomic, strong) ImageTextView *nickNameTextView;

@property (nonatomic, strong) UILabel *joinTimeLabel;

@property (nonatomic, strong) UIButton *bindStatusButton;

@property (nonatomic, strong) XYPHBindAccountBindStatusView *bindStatusView;

@property (nonatomic, strong) MASConstraint *bottomConstraint;

@end

@implementation XYPHBindAccountUserCardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor greenColor];

        [self addSubview:self.wrapperView];
        [self.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.mas_equalTo(0);
            self.bottomConstraint = make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(100);
        }];

        [self.wrapperView addSubview:self.avatarView];
        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(64);
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(25);
        }];

        [self.wrapperView addSubview:self.bindStatusLabel];
        [self.bindStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10);
            make.top.mas_equalTo(18);
            make.width.mas_equalTo(56);
            make.height.mas_equalTo(18);
        }];
        
        NSArray *subviews = @[
                              self.nickNameTextView,
                              self.joinTimeLabel,
                              self.bindStatusButton
                              ];
        
        UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:subviews];
        stackView.spacing = 10;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentLeading;
        [self.wrapperView addSubview:stackView];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarView);
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(self.avatarView.mas_trailing).offset(20);
        }];

        [self insertSubview:self.bindStatusView atIndex:0];
        [self.bindStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.centerX.mas_equalTo(self.wrapperView);
            make.leading.mas_equalTo(self.wrapperView).offset(8);
        }];
    }
    return self;
}

- (BOOL)isExpanding {
    return self.bindStatusButton.isSelected;
}

- (void)setIsExpanding:(BOOL)isExpanding animated:(BOOL)animated {
    if (isExpanding == self.isExpanding) {
        return;
    }
    self.bindStatusButton.selected = isExpanding;
    [self bindStatusViewUpdateLayout:isExpanding animated:animated];
}

- (void)updateViewData:(XYPHBindAccountUserCardCellItem *)viewData {
    
    UIColor *bindStatusLabelColor;
    
    if (viewData.isBinding) {
        self.bindStatusLabel.text = @"当前绑定";
        bindStatusLabelColor = [UIColor redColor];
    } else {
        self.bindStatusLabel.text = @"当前登录";
        bindStatusLabelColor = [UIColor lightGrayColor];
    }
    
    self.bindStatusLabel.layer.borderColor = bindStatusLabelColor.CGColor;
    self.bindStatusLabel.textColor = bindStatusLabelColor;
    
    self.nickNameTextView.text = @"小姐姐";
    self.joinTimeLabel.text = @"2017.12.31 加入小红书";
    
    NSArray *icontypes = @[
                           @"qq",
                           @"weixin",
                           @"weibo",
                           @"facebook",
                           @"mobile"
                           ];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *icontype in icontypes) {
        XYPHBindAccountBindStatusViewItem *item = [XYPHBindAccountBindStatusViewItem new];
        item.text = icontype;
        item.socialType = icontype;
        [items addObject:item];
    }
    [self.bindStatusView updateViewData:items];
}

- (void)bindStatusViewUpdateLayout:(BOOL)isExpanding animated:(BOOL)animated {
    void (^animations)(void) = ^{
        [self.bindStatusView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.wrapperView);
            make.leading.mas_equalTo(self.wrapperView).offset(8);
            make.bottom.mas_equalTo(0);
            if (isExpanding) {
                [self.bottomConstraint deactivate];
                make.top.mas_equalTo(self.wrapperView.mas_bottom).offset(-10);
            } else {
                make.top.mas_equalTo(self.wrapperView);
                [self.bottomConstraint activate];
            }
        }];
        [self layoutIfNeeded];
    };
    if (animated) {
        [UIView animateWithDuration:0.25 animations:animations];
    } else {
        animations();
    }
}

#pragma mark - Action
- (void)showAccountBindStatus:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ([self.delegate respondsToSelector:@selector(userCardView:willTransform:)]) {
        [self.delegate userCardView:self willTransform:sender.isSelected];
    }
    [self bindStatusViewUpdateLayout:sender.isSelected animated:YES];
    if ([self.delegate respondsToSelector:@selector(userCardView:didTransform:)]) {
        [self.delegate userCardView:self didTransform:self.isExpanding];
    }
}

- (UIView *)wrapperView {
    if (!_wrapperView) {
        _wrapperView = [UIView new];
        _wrapperView.backgroundColor = [UIColor whiteColor];
        _wrapperView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _wrapperView.layer.cornerRadius = 4;
        _wrapperView.layer.shadowOpacity = 0.8f;
        _wrapperView.layer.shadowOffset = CGSizeMake(0, 2);
    }
    return _wrapperView;
}

- (XYPHBindAccountBindStatusView *)bindStatusView {
    if (!_bindStatusView) {
        _bindStatusView = [XYPHBindAccountBindStatusView new];
        _bindStatusView.backgroundColor = [UIColor whiteColor];
        _bindStatusView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _bindStatusView.layer.cornerRadius = 4;
        _bindStatusView.layer.shadowOpacity = 0.8f;
        _bindStatusView.layer.shadowOffset = CGSizeMake(0, 2);
    }
    return _bindStatusView;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarView.layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _avatarView.layer.cornerRadius = 32;
    }
    return _avatarView;
}

- (UILabel *)bindStatusLabel {
    if (!_bindStatusLabel) {
        _bindStatusLabel = [UILabel new];
        _bindStatusLabel.font = [UIFont systemFontOfSize:11];
        _bindStatusLabel.textAlignment = NSTextAlignmentCenter;
        _bindStatusLabel.layer.borderWidth = 0.5;
        _bindStatusLabel.layer.cornerRadius = 2;
    }
    return _bindStatusLabel;
}

- (ImageTextView *)nickNameTextView {
    if (!_nickNameTextView) {
        _nickNameTextView = [ImageTextView new];
        _nickNameTextView.imagePosition = ImageTextViewPositionRight;
        _nickNameTextView.textFont = [UIFont boldSystemFontOfSize:15];
    }
    return _nickNameTextView;
}

- (UILabel *)joinTimeLabel {
    if (!_joinTimeLabel) {
        _joinTimeLabel = [UILabel new];
        _joinTimeLabel.font = [UIFont systemFontOfSize:11];
    }
    return _joinTimeLabel;
}

- (UIButton *)bindStatusButton {
    if (!_bindStatusButton) {
        _bindStatusButton = [UIButton new];
        _bindStatusButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _bindStatusButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _bindStatusButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _bindStatusButton.adjustsImageWhenHighlighted = NO;
        //        button.semanticContentAttribute = .forceRightToLeft iOS 9
        //        CGFloat spacing = 5;
        //        _bindStatusButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, spacing);
        //        _bindStatusButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        [_bindStatusButton setImage:[UIImage imageNamed:@"icon_downarrow_grey_17"] forState:UIControlStateNormal];
        [_bindStatusButton setImage:[UIImage imageNamed:@"icon_uparrow_grey_17"] forState:UIControlStateSelected];
        [_bindStatusButton setTitle:@"账号已绑定状态  " forState:UIControlStateNormal];
        [_bindStatusButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
        _bindStatusButton.titleLabel.font = [UIFont systemFontOfSize:11];
        [_bindStatusButton addTarget:self action:@selector(showAccountBindStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bindStatusButton;
}

@end
