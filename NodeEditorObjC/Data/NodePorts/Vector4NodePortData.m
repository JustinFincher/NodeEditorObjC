//
//  Vector4NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector4NodePortData.h"
#import "Vector4.h"

@implementation Vector4NodePortData
+ (NSString *)templateTitle
{
    return @"Vector4";
}

+ (Class)templateRequiredType
{
    return [Vector4 class];
}
@end
