//
//  ViewController.m
//  KenTagSelectorDemo
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "ViewController.h"
#import <KenTagSelector/KenTagSelector.h>

@interface ViewController ()
{
    __block NSMutableArray *selectedTagArray;
    __block NSMutableArray *otherTagArray;
    NSArray     *residentArray;
}

@property (weak, nonatomic) IBOutlet UILabel *labelSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedTagArray = @[@"关注",@"头条",@"抗疫",@"北京",@"科技",@"汽车",@"社会",@"军事",@"知否",@"历史",@"要闻",@"财经",@"军事"].mutableCopy;
    otherTagArray = @[@"独家",@"航空",@"娱乐",@"影视",@"音乐",@"股票",@"体育",@"CBA",@"冬奥",@"手机",@"数码",@"房产",@"游戏",@"旅游",@"健康",@"亲子",@"时尚",@"艺术",@"星座",@"段子",@"跟帖",@"图片",@"萌宠",@"圈子"].mutableCopy;
    residentArray = @[@"关注", @"头条"];
    
    NSMutableString *strSelected = [NSMutableString new];
    for (NSString *tag in selectedTagArray)
    {
        [strSelected appendString:tag];
        [strSelected appendString:@", "];
    }
    _labelSelected.text = strSelected;
}

- (IBAction)onBtnSelectClicked:(id)sender {
    
    TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:selectedTagArray andOtherTags:otherTagArray];
    selectorVC.residentTagStringArray = residentArray;
    
    [self presentViewController:selectorVC animated:YES completion:^{}];
    
    //返回所有选中栏目
    __block  NSMutableString *_str = [NSMutableString new];
    selectorVC.choosedTags = ^(NSArray *selectedTags, NSArray *otherTags) {
        self->selectedTagArray = @[].mutableCopy;
        self->otherTagArray = @[].mutableCopy;
        for (Channel *channel in otherTags) {
            [self->otherTagArray addObject:channel.title];
        }
        for (Channel *channel in selectedTags) {
            [self->selectedTagArray addObject:channel.title];
            [_str appendString:channel.title];
            [_str appendString:@", "];
        }
        self->_labelSelected.text = _str;
    };
    
    //用户点击了某个栏目的处理Block
    selectorVC.activeTag = ^(Channel *channel) {
        [_str appendString:channel.title];
        self->_labelSelected.text = _str;
    };
}


@end
