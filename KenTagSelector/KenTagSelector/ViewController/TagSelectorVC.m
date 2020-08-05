//
//  TagSelectorVC.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import "TagSelectorVC.h"
#import "SelectedHeaderView.h"
#import "UnselectedHeaderView.h"
#import "KenTagSelectorUtils.h"

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define HEAD_SELECTED   @"head_selected"
#define HEAD_OTHER      @"head_other"

@interface TagSelectorVC () <UICollectionViewDelegate,UICollectionViewDataSource,ChannelCellDelegate>
{
    NSMutableArray *_selectedTags;
    NSMutableArray *_otherTags;

    BOOL _isEditMode;       //是否处于编辑状态
}
@end

@implementation TagSelectorVC

-(instancetype)initWithSelectedTags:(NSArray *)selectedTags andOtherTags:(NSArray *)otherTags {
    
    self = [super init];
    if (self) {
        _selectedTagStringArray = selectedTags.mutableCopy;
        _otherTagStringArray = otherTags.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [KenTagSelectorUtils colorNamed:@"background_color"];
    
    _isEditMode = NO;
    
    //将StringArray转为ChannelArray
    [self initTags];
    
    //初始化界面
    [self setupViews];
    
}

- (void)initTags {
    _selectedTags = @[].mutableCopy;
    _otherTags = @[].mutableCopy;
    for (NSString *title in _selectedTagStringArray) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        mod.resident = NO;
        for (NSString * resident in _residentTagStringArray) {
            if ([resident isEqualToString:title]) {
                mod.resident = YES;     //在residentTagStringArray中存在，说明是不允许取消选择的Tag
            }
        }

        mod.editable = YES;
        mod.selected = NO;
        mod.tagType = SelectedChannel;

        [_selectedTags addObject:mod];
    }
    for (NSString *title in _otherTagStringArray) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        mod.editable = NO;
        mod.selected = NO;
        mod.tagType = OtherChannel;
        [_otherTags addObject:mod];
    }
}

- (void)setupViews{
    
    //退出按钮
    UIButton *exit = [[UIButton alloc]init];
    [self.view addSubview:exit];
    exit.frame = CGRectMake(KScreenWidth - 32 - 15, 15, 32, 32);
    [exit setImage:[KenTagSelectorUtils imageNamed:@"close_selector"] forState:UIControlStateNormal];
    exit.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [exit addTarget:self action:@selector(returnLast) forControlEvents:UIControlEventTouchUpInside];
    
    //总标题
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, KScreenWidth - 30, 30)];
    labelTitle.font = [UIFont systemFontOfSize:18];
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.text = @"全部栏目";
    labelTitle.textColor = [KenTagSelectorUtils colorNamed:@"title_color"];
    [self.view addSubview:labelTitle];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _collectionMain = [[UICollectionView alloc]initWithFrame:CGRectMake(0, exit.frame.origin.y+exit.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 80) collectionViewLayout:layout];
    [self.view addSubview:_collectionMain];
    _collectionMain.backgroundColor = [UIColor clearColor];
    [_collectionMain registerClass:[ChannelCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionMain registerClass:[SelectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_SELECTED];
    [_collectionMain registerClass:[UnselectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEAD_OTHER];
    _collectionMain.delegate = self;
    _collectionMain.dataSource = self;
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_collectionMain addGestureRecognizer:longPress];
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击坐标
    CGPoint point=[longPress locationInView:_collectionMain];
    
    NSIndexPath *indexPath=[_collectionMain indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [_collectionMain beginInteractiveMovementForItemAtIndexPath:indexPath];

    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [_collectionMain updateInteractiveMovementTargetPosition:point];

    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [_collectionMain endInteractiveMovement];

    } else {
        [_collectionMain cancelInteractiveMovement];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _selectedTags.count;
    }else{
        return _otherTags.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    ChannelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_selectedTags.count>indexPath.item) {
            cell.model = _selectedTags[indexPath.item];
            cell.btnDel.tag = indexPath.item;
            cell.delegate = self;
            if (_isEditMode) {
                if (cell.model.resident) {
                    cell.btnDel.hidden = YES;
                }else{
                    if (!cell.model.editable) {
                        cell.btnDel.hidden = YES;
                    }else{
                        cell.btnDel.hidden = NO;
                    }
                }
            }else{
                cell.btnDel.hidden = YES;
            }
        }
    }else if (indexPath.section == 1){
        if (_otherTags.count>indexPath.item) {
            cell.model = _otherTags[indexPath.item];
            cell.delegate = self;
//            if (_onEdit) {
//                cell.delBtn.hidden = NO;
//            }else{
                cell.btnDel.hidden = YES;
//            }
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScreenWidth / 4 - 10, 53);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 50);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            NSString *CellIdentifier = HEAD_SELECTED;
            SelectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [header.btnEdit addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];

            reusableview = header;
        }
    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = HEAD_OTHER;
            UnselectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            reusableview = header;
        }
    }
    return reusableview;
}

/** 进入编辑状态 */
- (void)editTags:(UIButton *)sender{
    
    if (!_isEditMode) {
        for (ChannelCollectionCell *items in _collectionMain.visibleCells) {
            if (items.model.tagType == SelectedChannel) {
                if (items.model.resident) {
                    items.btnDel.hidden = YES;
                }else{
                    items.btnDel.hidden = NO;
                }
            }
        }
        [sender setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        for (ChannelCollectionCell *items in _collectionMain.visibleCells) {
            if (items.model.tagType == SelectedChannel) {
                items.btnDel.hidden = YES;
            }
        }
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [_collectionMain reloadData];
    _isEditMode = !_isEditMode;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    ChannelCollectionCell *cell = (ChannelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.model.resident) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Channel *object= _selectedTags[sourceIndexPath.item];
    [_selectedTags removeObjectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [_selectedTags insertObject:object atIndex:destinationIndexPath.item];
    }else if (destinationIndexPath.section == 1) {
        object.tagType = OtherChannel;
        object.editable = NO;
        object.selected = NO;
        [_otherTags insertObject:object atIndex:destinationIndexPath.item];
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    
    [self refreshDelBtnsTag];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSInteger item = 0;
        for (Channel *mod in _selectedTags) {
            if (mod.selected) {
                mod.selected = NO;
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            }
            item++;
        }
        Channel *object = _selectedTags[indexPath.item];
        object.selected = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        typeof(self) __weak weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            //单选某个tag
            if (weakSelf.activeTag) {
                weakSelf.activeTag(object);
            }
        }];
    }else if (indexPath.section == 1) {
        ChannelCollectionCell *cell = (ChannelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.model.editable = YES;
        cell.model.tagType = SelectedChannel;
        cell.title.text = cell.model.title;

        //[_collectionMain reloadItemsAtIndexPaths:@[indexPath]];
        [_otherTags removeObjectAtIndex:indexPath.item];
        [_selectedTags addObject:cell.model];
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:_selectedTags.count-1 inSection:0];
        cell.btnDel.tag = targetIndexPage.item;
        cell.btnDel.hidden = !_isEditMode;
        [_collectionMain moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
    
    [self refreshDelBtnsTag];
}

-(void)deleteCell:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    ChannelCollectionCell *cell = (ChannelCollectionCell *)[_collectionMain cellForItemAtIndexPath:indexPath];
    cell.model.editable = NO;
    cell.model.tagType = OtherChannel;
    cell.model.selected = NO;
    cell.btnDel.hidden = YES;
    [_collectionMain reloadItemsAtIndexPaths:@[indexPath]];
    
    id object = _selectedTags[indexPath.item];
    [_selectedTags removeObjectAtIndex:indexPath.item];
    [_otherTags insertObject:object atIndex:0];
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [_collectionMain moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    [self refreshDelBtnsTag];
}

/** 刷新删除按钮的tag */
- (void)refreshDelBtnsTag{
    
    for (ChannelCollectionCell *cell in _collectionMain.visibleCells) {
        NSIndexPath *indexpath = [_collectionMain indexPathForCell:cell];
        cell.btnDel.tag = indexpath.item;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)returnLast{
    typeof(self) __weak weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.choosedTags) {
            weakSelf.choosedTags(self->_selectedTags,self->_otherTags);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
