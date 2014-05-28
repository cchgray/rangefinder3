//
//  UIbuttonPro.m
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 5/5/14.
//  Copyright (c) 2014 Carter Crenshaw Howard Gray. All rights reserved.
//

#import "UIbuttonPro.h"
#import <objc/runtime.h>

@implementation UIButton(Property)

static char UIB_PROPERTY_KEY;

@dynamic property;

-(void)setProperty:(NSObject *)property
{
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSObject*)property
{
    return (NSObject*)objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
}

@end