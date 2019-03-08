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

+ (NSString *) templateRequiredCgType
{
    return @"float";
}

- (NSString *)templateVariableDefaultValueExpressionRule
{
    return [NSString stringWithFormat:@"%@ %@ = %.8f;",[self requiredCgType], [self indexToVariableName],[@0 floatValue]];
}

+ (Class)templateRequiredType
{
    return [NSNumber class];
}

@end
