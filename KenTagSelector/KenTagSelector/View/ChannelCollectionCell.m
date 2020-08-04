//
//  ChannelCollectionCell.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "ChannelCollectionCell.h"

@implementation ChannelCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-10);
        _title.backgroundColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
        _title.layer.masksToBounds = YES;
        _title.layer.cornerRadius = 4;
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _title.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.00];
        
        _btnDel = [[UIButton alloc]init];
        [self.contentView addSubview:_btnDel];
        _btnDel.frame = CGRectMake(frame.size.width-18, 0, 18, 18);
        [_btnDel setImage:[UIImage imageNamed:@"channel_tag_delete"] forState:UIControlStateNormal];
        [_btnDel addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setModel:(Channel *)model{
    
    _model = model;
        
        if (model.tagType == SelectedChannel) {
            if (model.editable) {
            }else{
                model.editable = YES;
            }
            if (model.resident) {
                _btnDel.hidden = YES;
            }else{
                _btnDel.hidden = NO;
            }
            
            if (model.selected) {
                _title.textColor = [UIColor colorWithRed:0.5 green:0.26 blue:0.27 alpha:1.0];
            }else{
                _title.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.0];
            }
            
        } else if (model.tagType == OtherChannel) {
            if (model.editable) {
                model.editable = NO;
            }

            _btnDel.hidden = YES;
        }
        _title.text = (model.tagType == SelectedChannel) ? model.title : [@"＋" stringByAppendingString:model.title];
    
}

@end
