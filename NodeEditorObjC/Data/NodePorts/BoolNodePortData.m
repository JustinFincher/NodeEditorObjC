//
//  BoolNodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 10/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "BoolNodePortData.h"
#import "NodeBoolean.h"

@implementation BoolNodePortData

+ (NSString *)templateTitle
{
    return @"Boolean";
}

+ (NSString *) templateRequiredCgType
{
    return @"bool";
}

- (NSString *)templateVariableDefaultValueExpressionRule
{
    return [NSString stringWithFormat:@"%@ %@ = false;",
            [self requiredCgType],
            [self indexToVariableName]];
}

+ (Class)templateRequiredType
{
    return [NodeBoolean class];
}


@end
