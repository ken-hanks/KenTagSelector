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

typedef void(^ChoosedTags)(NSArray *chooseTags,NSArray *recommandTags);

typedef void(^SelectedTag)(Channel *channel);


@interface TagSelectorVC : UIViewController

@property (nonatomic, strong) UICollectionView *mainView;

@property (nonatomic, strong) NSMutableArray *myChannels;

@property (nonatomic, strong) NSMutableArray *recommandChannels;

@property (nonatomic, copy) ChoosedTags choosedTags;

@property (nonatomic, copy) SelectedTag selectedTag;

-(instancetype)initWithMyTags:(NSArray *)myTags andRecommandTags:(NSArray *)recommandTags;
@end

NS_ASSUME_NONNULL_END
