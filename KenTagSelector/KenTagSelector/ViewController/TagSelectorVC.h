//
//  TagSelectorVC.h
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoosedTags)(NSArray *selectedTags, NSArray *otherTags);

typedef void(^ActiveTag)(NSArray *selectedTags, NSArray *otherTags, Channel *activedTag, NSInteger index);


@interface TagSelectorVC : UIViewController

@property (nonatomic, strong) UICollectionView *collectionMain;

@property (nonatomic, strong) NSMutableArray *selectedTagStringArray;       //已被选中的Tag名

@property (nonatomic, strong) NSMutableArray *otherTagStringArray;          //待选的Tag名

@property (nonatomic, strong) NSArray *residentTagStringArray;              //不允许取消选择的Tag名

@property (nonatomic, strong) NSString *focusTitle;                         //焦点Tag的标题

@property (nonatomic, copy) ChoosedTags choosedTags;

@property (nonatomic, copy) ActiveTag   activeTag;

-(instancetype)initWithSelectedTags:(NSArray *)selectedTags andOtherTags:(NSArray *)otherTags;
@end

NS_ASSUME_NONNULL_END
