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
    __block NSMutableArray *_myTags;
    __block NSMutableArray *_recommandTags;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myTags = @[@"关注",@"推荐",@"热点",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食",@"北京",@"视频",@"社会",@"图片",@"娱乐",@"问答",@"科技",@"汽车",@"财经",@"军事",@"体育",@"段子",@"国际",@"趣图",@"健康",@"特卖",@"房产",@"美食"].mutableCopy;
    _recommandTags = @[@"小说",@"时尚",@"历史",@"育儿",@"直播",@"搞笑",@"数码",@"养生",@"电影",@"手机",@"旅游",@"宠物",@"情感",@"家居",@"教育",@"三农"].mutableCopy;
}

- (IBAction)onBtnSelectClicked:(id)sender {
    
    TagSelectorVC *controller = [[TagSelectorVC alloc]initWithMyTags:_myTags andRecommandTags:_recommandTags];
    [self presentViewController:controller animated:YES completion:^{}];
    
    //所有的已选的tags
    __block  NSMutableString *_str = @"已选：\n".mutableCopy;
    controller.choosedTags = ^(NSArray *chooseTags, NSArray *recommandTags) {
        _myTags = @[].mutableCopy;
        _recommandTags = @[].mutableCopy;
        for (Channel *mod in recommandTags) {
            [_recommandTags addObject:mod.title];
        }
        for (Channel *mod in chooseTags) {
            [_myTags addObject:mod.title];
            [_str appendString:mod.title];
            [_str appendString:@"、"];
        }
        //_tagLabel.text = _str;
    };
    
    //单选tag
    controller.selectedTag = ^(Channel *channel) {
        [_str appendString:channel.title];
        //_tagLabel.text = _str;
    };
}


@end
