//
//  NSString+SPRAdditions.m
//  SixParkReader
//
//  Created by Wyatt Lam on 10/1/14.
//  Copyright (c) 2014 Wyatt Lam. All rights reserved.
//

#import "NSString+SPRAdditions.h"

@implementation NSString (SPRAdditions)

- (BOOL)isNotNilOrEmpty
{
    return (self && (self.length != 0));
}

@end
