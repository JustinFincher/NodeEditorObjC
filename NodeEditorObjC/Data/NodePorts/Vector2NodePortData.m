//
//  Vector2NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector2NodePortData.h"
#import "NodeVector2.h"

@implementation Vector2NodePortData

+ (NSString *)templateTitle
{
    return @"Vector2";
}

+ (NSString *) templateRequiredCgType
{
    return @"vec2";
}

- (NSString *)templateVariableDefaultValueExpressionRule
{
    return [NSString stringWithFormat:@"%@ %@ = vec2(%.8f,%.8f);",
            [self requiredCgType],
            [self indexToVariableName],
            [@0 floatValue],
            [@0 floatValue]];
}

+ (Class)templateRequiredType
{
    return [NodeVector2 class];
}

@end
