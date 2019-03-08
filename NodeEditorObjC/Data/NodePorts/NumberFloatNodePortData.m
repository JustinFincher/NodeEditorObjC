//
//  NumberNodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NumberFloatNodePortData.h"

@implementation NumberFloatNodePortData

+ (NSString *)templateTitle
{
    return @"Number (float)";
}

+ (Class)templateRequiredType
{
    return [NSNumber class];
}

@end
