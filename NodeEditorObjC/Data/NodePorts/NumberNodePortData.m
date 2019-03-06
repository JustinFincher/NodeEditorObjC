//
//  NumberNodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NumberNodePortData.h"

@implementation NumberNodePortData

+ (NSString *)templateTitle
{
    return @"Number";
}

+ (Class)templateRequiredType
{
    return [NSNumber class];
}

@end
