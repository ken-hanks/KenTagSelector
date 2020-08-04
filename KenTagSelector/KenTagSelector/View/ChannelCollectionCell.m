//
//  ChannelCollectionCell.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "ChannelCollectionCell.h"
#import "KenTagSelectorUtils.h"

@implementation ChannelCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        _title = [[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title.frame = CGRectMake(2, 4, frame.size.width - 6, frame.size.height - 14);
        _title.backgroundColor = [KenTagSelectorUtils colorNamed:@"cell_background_color"];
        _title.layer.masksToBounds = YES;
        _title.layer.cornerRadius = _title.frame.size.height / 2;
        _title.layer.borderColor = [KenTagSelectorUtils colorNamed:@"cell_border_color"].CGColor;
        _title.layer.borderWidth = 0.5;
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.numberOfLines = 0;
        _title.textColor = [KenTagSelectorUtils colorNamed:@"cell_text_color"];
        
        _btnDel = [[UIButton alloc]init];
        [self.contentView addSubview:_btnDel];
        _btnDel.frame = CGRectMake(frame.size.width - 18, 0, 18, 18);

        UIImage *img = [UIImage imageNamed:@"channel_tag_delete" inBundle:[KenTagSelectorUtils getBundle] compatibleWithTraitCollection:nil];
        [_btnDel setImage:img forState:UIControlStateNormal];
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
            
//            if (model.selected) {
//                _title.textColor = [KenTagSelectorUtils colorNamed:@"focus_color"];
//            }else{
                _title.textColor = [KenTagSelectorUtils colorNamed:@"cell_text_color"];
            //}
            
        } else if (model.tagType == OtherChannel) {
            if (model.editable) {
                model.editable = NO;
            }

            _btnDel.hidden = YES;
        }
        _title.text = (model.tagType == SelectedChannel) ? model.title : [@"＋" stringByAppendingString:model.title];
    
}

- (void)delete:(UIButton *)sender{
    
    [_delegate deleteCell:sender];
}
@end
