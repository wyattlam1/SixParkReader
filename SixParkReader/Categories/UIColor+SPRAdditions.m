//
//  UIColor+SPRAdditions.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "UIColor+SPRAdditions.h"

@implementation UIColor (SPRAdditions)

+ (UIColor *)spr_lightGreen
{
    return [UIColor colorWithRed:160.f/255.f green:216/255.f blue:128.f/255.f alpha:1.f];
}

+ (UIColor *)spr_lightGray
{
    return [UIColor colorWithWhite:0.6 alpha:1.f];
}

@end
