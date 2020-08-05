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
    
    selectedTagArray = @[@"关注",@"推荐",@"热点",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食"].mutableCopy;
    otherTagArray = @[@"小说",@"时尚",@"历史",@"育儿",@"直播",@"搞笑",@"数码",@"养生",@"电影",@"手机",@"旅游",@"宠物",@"情感",@"家居",@"教育",@"三农"].mutableCopy;
    residentArray = @[@"关注"];
    
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
