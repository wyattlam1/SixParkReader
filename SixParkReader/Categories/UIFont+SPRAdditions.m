//
//  UIFont+SPRAdditions.m
//  SixParkReader
//
//  Created by Wyatt Lam on 9/26/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "UIFont+SPRAdditions.h"

@implementation UIFont (SPRAdditions)

+ (UIFont *)spr_defaultChineseFont
{
    return [UIFont fontWithName:@"STHeitiSC-Light" size:20.f];
}

+ (UIFont *)spr_headerFont
{
    return [UIFont fontWithName:@"STHeitiSC-Medium" size:32.f];
}

@end
