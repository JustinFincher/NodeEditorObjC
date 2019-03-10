//
//  Vector4NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector4NodePortData.h"
#import "NodeVector4.h"

@implementation Vector4NodePortData
+ (NSString *)templateTitle
{
    return @"Vector4";
}

+ (NSString *) templateRequiredCgType
{
    return @"vec4";
}

- (NSString *)templateVariableDefaultValueExpressionRule
{
    return [NSString stringWithFormat:@"%@ %@ = vec4(%.8f,%.8f,%.8f,%.8f);",
            [self requiredCgType],
            [self indexToVariableName],
            [@0 floatValue],
            [@0 floatValue],
            [@0 floatValue],
            [@0 floatValue]];
}

+ (Class)templateRequiredType
{
    return [NodeVector4 class];
}
@end
