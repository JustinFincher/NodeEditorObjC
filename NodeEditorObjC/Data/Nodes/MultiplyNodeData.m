//
//  MultiplyNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "MultiplyNodeData.h"
#import "NumberFloatNodePortData.h"

@implementation MultiplyNodeData

+ (NSString *)templateTitle
{
    return @"Multiply (*)";
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberExportPort = [[NumberFloatNodePortData alloc] init];
    numberExportPort.title = @"Result";
    [array addObject:numberExportPort];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberAPort = [[NumberFloatNodePortData alloc] init];
    numberAPort.title = @"A";
    [array addObject:numberAPort];
    NumberFloatNodePortData *numberBPort = [[NumberFloatNodePortData alloc] init];
    numberBPort.title = @"B";
    [array addObject:numberBPort];
    return array;
}

+ (BOOL)templateCanHavePreview
{
    return YES;
}
+ (int)templatePreviewForOutPortIndex
{
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
                         "float %@ = %@ * %@;",
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
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:1] indexToVariableName]];
    return string;
}
@end
