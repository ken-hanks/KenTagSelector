//
//  Utils.m
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "KenTagSelectorUtils.h"

@implementation KenTagSelectorUtils
+ (NSBundle*)getBundle
{
    NSString *path;
    if ((path = [[NSBundle mainBundle] pathForResource:@"KenTagSelector" ofType:@"framework" inDirectory:@"Frameworks"]) != nil)
    {
        return [NSBundle bundleWithPath:path];
    }
    else if((path = [[NSBundle bundleForClass:[KenTagSelectorUtils class]] pathForResource:@"KenTagSelector" ofType:@"bundle"]) != nil)
    {
        return [NSBundle bundleWithPath:path];
    }
    return nil;
}

#pragma mark - 从Bundle中获取指定名字的图片
+ (UIImage*)imageNamed:(NSString*)imageName
{
    UIImage *image = [UIImage imageNamed:imageName
                                inBundle:[KenTagSelectorUtils getBundle]
           compatibleWithTraitCollection:nil];
    return image;
}

#pragma mark - 从Bundle获取指定名字的颜色
+ (UIColor*)colorNamed:(NSString*)colorName
{
    UIColor *color = [UIColor colorNamed:colorName inBundle:[KenTagSelectorUtils getBundle] compatibleWithTraitCollection:nil];
    return color;
}
@end
