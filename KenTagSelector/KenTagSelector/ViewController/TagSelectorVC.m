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

#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)

@interface TagSelectorVC () <UICollectionViewDelegate,UICollectionViewDataSource,ChannelCellDelegate>
{
    NSMutableArray *_myTags;
    NSMutableArray *_recommandTags;

    BOOL _onEdit;//tag处在编辑状态
    BOOL _tagDeletable;//在长按tag的时候是否可以删除该tag
}
@end

@implementation TagSelectorVC

-(instancetype)initWithMyTags:(NSArray *)myTags andRecommandTags:(NSArray *)recommandTags{
    
    self = [super init];
    if (self) {
        _myChannels = myTags.mutableCopy;
        _recommandChannels = recommandTags.mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.00];
    //加载数据
    [self makeTags];
    //视图
    [self setupViews];
    
    _onEdit = NO;
    
}

- (void)makeTags{
    _myTags = @[].mutableCopy;
    _recommandTags = @[].mutableCopy;
    for (NSString *title in _myChannels) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = YES;
        mod.selected = NO;
        mod.tagType = SelectedChannel;
        //demo默认选择第一个
        if ([title isEqualToString:@"关注"]) {
            mod.selected = YES;
        }
        [_myTags addObject:mod];
    }
    for (NSString *title in _recommandChannels) {
        Channel *mod = [[Channel alloc]init];
        mod.title = title;
        if ([title isEqualToString:@"关注"]||[title isEqualToString:@"推荐"]) {
            mod.resident = YES;//常驻
        }
        mod.editable = NO;
        mod.tagType = OtherChannel;
        [_recommandTags addObject:mod];
    }
}

- (void)setupViews{
    
    UIButton *exit = [[UIButton alloc]init];
    [self.view addSubview:exit];
    exit.frame = CGRectMake(15, 30, 20, 20);
    [exit setImage:[UIImage imageNamed:@"Exit"] forState:UIControlStateNormal];
    exit.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [exit addTarget:self action:@selector(returnLast) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _mainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, exit.frame.origin.y+exit.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-40) collectionViewLayout:layout];
    [self.view addSubview:_mainView];
    _mainView.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:1.00];
    [_mainView registerClass:[ChannelCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_mainView registerClass:[SelectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head1"];
    [_mainView registerClass:[UnselectedHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head2"];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    //添加长按的手势
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_mainView addGestureRecognizer:longPress];
}

- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:_mainView];
    //从长按开始
    NSIndexPath *indexPath=[_mainView indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [_mainView beginInteractiveMovementForItemAtIndexPath:indexPath];
        if (_onEdit) {
        }else{
            //[self editTags:_editBtn];
        }
        _tagDeletable = NO;
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        [_mainView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [_mainView endInteractiveMovement];
        _tagDeletable = YES;
        //其他情况
    } else {
        [_mainView cancelInteractiveMovement];
    }
}

#pragma mark- collection datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _myTags.count;
    }else{
        return _recommandTags.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellIdentifier";
    ChannelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (_myTags.count>indexPath.item) {
            cell.model = _myTags[indexPath.item];
            cell.btnDel.tag = indexPath.item;
            cell.delegate = self;
            if (_onEdit) {
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
        if (_recommandTags.count>indexPath.item) {
            cell.model = _recommandTags[indexPath.item];
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

#pragma mark- collection delegate
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
            NSString *CellIdentifier = @"head1";
            SelectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            [header.btnEdit addTarget:self action:@selector(editTags:) forControlEvents:UIControlEventTouchUpInside];

            reusableview = header;
        }
    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader){
            NSString *CellIdentifier = @"head2";
            UnselectedHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
            reusableview = header;
        }
    }
    return reusableview;
}

/** 进入编辑状态 */
- (void)editTags:(UIButton *)sender{
    
    if (!_onEdit) {
        for (ChannelCollectionCell *items in _mainView.visibleCells) {
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
        for (ChannelCollectionCell *items in _mainView.visibleCells) {
            if (items.model.tagType == SelectedChannel) {
                items.btnDel.hidden = YES;
            }
        }
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _onEdit = !_onEdit;
    
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
    Channel *object= _myTags[sourceIndexPath.item];
    [_myTags removeObjectAtIndex:sourceIndexPath.item];
    if (destinationIndexPath.section == 0) {
        [_myTags insertObject:object atIndex:destinationIndexPath.item];
    }else if (destinationIndexPath.section == 1) {
        object.tagType = OtherChannel;
        object.editable = NO;
        object.selected = NO;
        [_recommandTags insertObject:object atIndex:destinationIndexPath.item];
        [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];
    }
    
    [self refreshDelBtnsTag];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSInteger item = 0;
        for (Channel *mod in _myTags) {
            if (mod.selected) {
                mod.selected = NO;
                [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]]];
            }
            item++;
        }
        Channel *object = _myTags[indexPath.item];
        object.selected = YES;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        typeof(self) __weak weakSelf = self;
        [self dismissViewControllerAnimated:YES completion:^{
            //单选某个tag
            if (weakSelf.selectedTag) {
                weakSelf.selectedTag(object);
            }
        }];
    }else if (indexPath.section == 1) {
        ChannelCollectionCell *cell = (ChannelCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.model.editable = YES;
        cell.model.tagType = SelectedChannel;
        cell.title.text = cell.model.title;

        //[_mainView reloadItemsAtIndexPaths:@[indexPath]];
        [_recommandTags removeObjectAtIndex:indexPath.item];
        [_myTags addObject:cell.model];
        NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:_myTags.count-1 inSection:0];
        cell.btnDel.tag = targetIndexPage.item;
        cell.btnDel.hidden = !_onEdit;
        [_mainView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    }
    
    [self refreshDelBtnsTag];
}

-(void)deleteCell:(UIButton *)sender{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    ChannelCollectionCell *cell = (ChannelCollectionCell *)[_mainView cellForItemAtIndexPath:indexPath];
    cell.model.editable = NO;
    cell.model.tagType = OtherChannel;
    cell.model.selected = NO;
    cell.btnDel.hidden = YES;
    [_mainView reloadItemsAtIndexPaths:@[indexPath]];
    
    id object = _myTags[indexPath.item];
    [_myTags removeObjectAtIndex:indexPath.item];
    [_recommandTags insertObject:object atIndex:0];
    NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
    [_mainView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
    [self refreshDelBtnsTag];
}

/** 刷新删除按钮的tag */
- (void)refreshDelBtnsTag{
    
    for (ChannelCollectionCell *cell in _mainView.visibleCells) {
        NSIndexPath *indexpath = [_mainView indexPathForCell:cell];
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
            weakSelf.choosedTags(self->_myTags,self->_recommandTags);
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
