//
//  Utils.h
//  KenTagSelector
//
//  Created by KANG HAN on 2020/8/4.
//  Copyright © 2020 KANG HAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KenTagSelectorUtils : NSObject
+ (NSBundle*)getBundle;
+ (UIImage*)imageNamed:(NSString*)imageName;
+ (UIColor*)colorNamed:(NSString*)colorName;
@end

NS_ASSUME_NONNULL_END
