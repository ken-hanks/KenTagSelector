# KenTagSelector
A tag selector written by Objective-C. （一个类似网易栏目选择器的标签选择界面）

## 功能特性
  + 用户可单选栏目或将栏目加入选择列表。
  + 可设置固定栏目，固定栏目不能被删除。
  + 已选栏目列表支持拖拽排序。
  + 已适配iOS13的暗黑模式。

![选择栏目](https://github.com/ken-hanks/KenTagSelector/blob/master/KenTagSelector/ScreenShot/E8DA58A7-50F9-4E42-9F32-AF787D8A62D1.png)
![编辑栏目界面](https://github.com/ken-hanks/KenTagSelector/blob/master/KenTagSelector/ScreenShot/5A65FB0F-1081-4F51-AB9B-37B01F093F61.png)
![已适配暗黑模式](https://github.com/ken-hanks/KenTagSelector/blob/master/KenTagSelector/ScreenShot/55FBD6DC-688B-41F8-9D5F-056CAF788E98.png)
![动画效果](https://github.com/ken-hanks/KenTagSelector/blob/master/KenTagSelector/ScreenShot/QQ20200805-142228.gif)

## 安装方法
### 使用CocoaPods （推荐）
  1. 在 Podfile 中添加一行 pod 'KenTagSelector'。
  2. 执行 pod install 或 pod update。

### 手工安装
  1. 点击"Code"按钮，选择"Download ZIP"，将代码下载到本地。
  2. 将ZIP文件解压，进入解压后的目录，用Xcode打开KenTagSelector.xcodeproj工程。
  3. 按Command+B编译，编译成功后，在Products目录下会生成KenTagSelector.framework。
  4. 在KenTagSelector.framework上点击鼠标右键，选“Show in Finder“，即可找到编译后的framework文件。
  5. 将KenTagSelector.framework插入到您的项目中。

## 使用说明

```

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
    
    //已选栏目列表
    selectedTagArray = @[@"关注",@"头条",@"抗疫",@"北京",@"科技",@"汽车",@"社会",@"军事",@"知否",@"历史",@"要闻",@"财经",@"军事"].mutableCopy;
    
    //备选栏目列表
    otherTagArray = @[@"独家",@"航空",@"娱乐",@"影视",@"音乐",@"股票",@"体育",@"CBA",@"冬奥",@"手机",@"数码",@"房产",@"游戏",@"旅游",@"健康",@"亲子",@"时尚",@"艺术",@"星座",@"段子",@"跟帖",@"图片",@"萌宠",@"圈子"].mutableCopy;
    
    //固定栏目列表（可选），注意：这个列表里的文字必须在“已选栏目列表”中存在，否则设了也没有用
    residentArray = @[@"关注", @"头条"];
    
}

//“选择栏目列表”按钮被点击的处理
- (IBAction)onBtnSelectClicked:(id)sender {
    
    //创建栏目选择器，输入已选栏目列表和备选栏目列表
    TagSelectorVC *selectorVC = [[TagSelectorVC alloc] initWithSelectedTags:selectedTagArray andOtherTags:otherTagArray];
    
    //设置固定栏目（可选步骤）
    selectorVC.residentTagStringArray = residentArray;
    
    //弹出栏目选择界面
    [self presentViewController:selectorVC animated:YES completion:^{}];
    
    //返回所有选中栏目
    __block  NSMutableString *strChannels = [NSMutableString new];
    selectorVC.choosedTags = ^(NSArray *selectedTags, NSArray *otherTags) {
        self->selectedTagArray = @[].mutableCopy;
        self->otherTagArray = @[].mutableCopy;
        for (Channel *channel in otherTags) {
            [self->otherTagArray addObject:channel.title];
        }
        for (Channel *channel in selectedTags) {
            [self->selectedTagArray addObject:channel.title];
            [strChannels appendString:channel.title];
            [strChannels appendString:@", "];
        }
        self->_labelSelected.text = strChannels;  //将选中的栏目在Label中显示
    };
    
    //用户点击了某个栏目的处理Block
    selectorVC.activeTag = ^(Channel *channel) {
        [strChannels appendString:channel.title];
        self->_labelSelected.text = strChannels;  //将选中的栏目在Label中显示
    };
}


@end
```
