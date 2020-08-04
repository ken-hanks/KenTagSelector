//
//  SelectedHeaderView.m
//  ChannelTag
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 Shin. All rights reserved.
//

#import "SelectedHeaderView.h"

@implementation SelectedHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab1 = [[UILabel alloc]init];
        [self addSubview:lab1];
        lab1.text = @"我的频道";
        lab1.frame = CGRectMake(20, 0, 100, 60);
        lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        
        UILabel *lab2 = [[UILabel alloc]init];
        [self addSubview:lab2];
        lab2.text = @"点击进入频道";
        lab2.font = [UIFont systemFontOfSize:13];
        lab2.frame = CGRectMake(100, 2, 200, 60);
        lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        
        _btnEdit = [[UIButton alloc] init];
        _btnEdit.frame = CGRectMake(frame.size.width-60, 13, 44, 28);
        [self addSubview:_btnEdit];
        [_btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        _btnEdit.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btnEdit setTitleColor:[UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0] forState:UIControlStateNormal];
        _btnEdit.layer.borderColor = [UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0].CGColor;
        _btnEdit.layer.masksToBounds = YES;
        _btnEdit.layer.cornerRadius = 14;
        _btnEdit.layer.borderWidth = 0.8;
        //[_btnEdit addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
@end
