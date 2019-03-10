//
//  SetNumberFloatNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 10/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "BranchNumberFloatNodeData.h"
#import "NumberFloatNodePortData.h"
#import "BoolNodePortData.h"

@implementation BranchNumberFloatNodeData

+ (NSString *)templateTitle
{
    return @"Branch (O = I ? A : B)";
}

+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    
    NumberFloatNodePortData *numberPortAData = [[NumberFloatNodePortData alloc] init];
    numberPortAData.title = @"True Value";
    [array addObject:numberPortAData];
    
    NumberFloatNodePortData *numberPortBData = [[NumberFloatNodePortData alloc] init];
    numberPortBData.title = @"False Value";
    [array addObject:numberPortBData];
    
    BoolNodePortData *boolPortData = [[BoolNodePortData alloc] init];
    boolPortData.title = @"If";
    [array addObject:boolPortData];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    
    NumberFloatNodePortData *numberPortData = [[NumberFloatNodePortData alloc] init];
    numberPortData.title = @"Out";
    [array addObject:numberPortData];
    
    return array;
}
+ (BOOL)templateCanHavePreview
{
    return YES;
}
+ (int)templatePreviewForOutPortIndex
{
    int a = 0;
    int b = 1;
    int f = true ? a : b;
    return 0;
}

- (NSString *)templatePreviewOutDefaultExpression
{
    return [NSString stringWithFormat:@"gl_FragColor = vec4(%@,%@,%@,%@); \n",
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName]];
}

- (NSString *)expressionRule
{
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "%@ \n"
                         "%@ \n"
                         "float %@ = %@;"
                         "if(%@ == true) { %@ = %@; } else{ %@ = %@; }",
                         [self nodeCommentHeader],
                         (
                          [[self.inPorts objectAtIndex:0] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:0] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:0] templateVariableDefaultValueExpressionRule]
                          ),
                         (
                          [[self.inPorts objectAtIndex:1] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:1] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:1] templateVariableDefaultValueExpressionRule]
                          ),
                         (
                          [[self.inPorts objectAtIndex:2] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:2] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:2] templateVariableDefaultValueExpressionRule]
                          ),
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [NSString stringWithFormat:@"%.8f",[@0 floatValue]],
                         [[self.inPorts objectAtIndex:2] indexToVariableName],
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:1] indexToVariableName]];
    return string;
}

@end
