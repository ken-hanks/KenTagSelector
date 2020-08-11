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
    NSString    *focusTitle;
}

@property (weak, nonatomic) IBOutlet UILabel *labelSelected;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //已选栏目列表
    selectedTagArray = @[@"关注",@"头条",@"抗疫",@"北京",@"科技",@"汽车",@"社会",@"军事",@"知否",@"历史",@"要闻",@"财经",@"军事"].mutableCopy;
    
    //备选栏目列表
    otherTagArray = @[@"独家",@"航空",@"娱乐",@"影视",@"音乐",@"股票",@"体育",@"CBA",@"冬奥",@"手机",@"数码",@"房产",@"游戏",@"旅游",@"健康",@"亲子",@"时尚",@"艺术",@"星座",@"段子",@"跟帖",@"图片",@"萌宠",@"圈子"].mutableCopy;
    
    //固定栏目列表（可选），注意：这个列表里的文字必须在“已选栏目列表”中存在，否则设了也没有用
    residentArray = @[@"关注", @"头条"];
    
    //焦点栏目（可选）
    focusTitle = @"头条";
    
    NSMutableString *strSelected = [NSMutableString new];
    for (NSString *tag in selectedTagArray)
    {
        [strSelected appendString:tag];
        [strSelected appendString:@", "];
    }
    _labelSelected.text = strSelected;
}

- (IBAction)onBtnSelectClicked:(id)sender {
    
    //创建栏目选择器，输入已选栏目列表和备选栏目列表
    TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:selectedTagArray andOtherTags:otherTagArray];
    
    //设置固定栏目（可选步骤）
    selectorVC.residentTagStringArray = residentArray;
    
    //设置焦点栏目（可选步骤)
    selectorVC.focusTitle = focusTitle;
    
    //弹出栏目选择界面
    [self presentViewController:selectorVC animated:YES completion:^{}];
    
    //返回所有选中栏目
    __block  NSMutableString *strChannels = [NSMutableString new];
    selectorVC.choosedTags = ^(NSArray *selectedTags, NSArray *otherTags) {
        self->selectedTagArray = @[].mutableCopy;
        self->otherTagArray = @[].mutableCopy;
        for (Channel *channel in otherTags) {
            [self->otherTagArray addObject:channel.title];
        }
        for (Channel *channel in selectedTags) {
            [self->selectedTagArray addObject:channel.title];
            [strChannels appendString:channel.title];
            [strChannels appendString:@", "];
        }
        self->_labelSelected.text = strChannels;
    };
    
    //用户点击了某个栏目的处理Block
    selectorVC.activeTag = ^(Channel *channel, NSInteger index) {
        [strChannels appendString:channel.title];
        self->_labelSelected.text = strChannels;
        self->focusTitle = channel.title;
        NSLog(@"Active index:%ld", index);
    };
}


@end
