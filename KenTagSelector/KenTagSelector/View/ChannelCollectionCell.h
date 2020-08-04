//
//  ChannelCollectionCell.h
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChannelCellDelegate

- (void)deleteCell:(UIButton *)sender;

@end

@interface ChannelCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title;           //栏目标题

@property (nonatomic, strong) UIButton * btnDel;        //删除按钮

@property (nonatomic, strong) Channel *model;           //数据模型

@property (nonatomic, weak) id <ChannelCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
