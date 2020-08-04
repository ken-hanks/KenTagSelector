//
//  UnselectedHeaderView.m
//  ChannelTag
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 Shin. All rights reserved.
//

#import "UnselectedHeaderView.h"

@implementation UnselectedHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *lab1 = [[UILabel alloc]init];
        [self addSubview:lab1];
        lab1.text = @"频道推荐";
        lab1.frame = CGRectMake(20, 0, 100, 60);
        lab1.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        
        UILabel *lab2 = [[UILabel alloc]init];
        [self addSubview:lab2];
        lab2.text = @"点击添加频道";
        lab2.font = [UIFont systemFontOfSize:13];
        lab2.frame = CGRectMake(100, 2, 200, 60);
        lab2.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
    }
    return self;
}
@end
