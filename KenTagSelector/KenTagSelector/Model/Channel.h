//
//  Channel.h
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 栏目类型：
        SelectedChannel: 已选中的栏目 （界面上部显示）
        OtherChannel: 其它栏目  （界面下部显示）
 */
typedef NS_ENUM(NSUInteger, ChannelType) {
    SelectedChannel,
    OtherChannel,
};

@interface Channel : NSObject
@property (nonatomic, assign) BOOL resident;
@property (nonatomic, assign) BOOL editable;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) ChannelType tagType;

@end

NS_ASSUME_NONNULL_END
