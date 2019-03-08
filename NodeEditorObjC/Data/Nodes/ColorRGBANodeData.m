//
//  FinalColorNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "ColorRGBANodeData.h"
#import "NumberFloatNodePortData.h"
#import "Vector4NodePortData.h"

@implementation ColorRGBANodeData

+ (NSString *)templateTitle
{
    return @"Color (RGBA)";
}

+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    
    NumberFloatNodePortData *numberImportRPort = [[NumberFloatNodePortData alloc] init];
    numberImportRPort.title = @"R";
    
    NumberFloatNodePortData *numberImportGPort = [[NumberFloatNodePortData alloc] init];
    numberImportGPort.title = @"G";
    
    NumberFloatNodePortData *numberImportBPort = [[NumberFloatNodePortData alloc] init];
    numberImportBPort.title = @"B";
    
    NumberFloatNodePortData *numberImportAPort = [[NumberFloatNodePortData alloc] init];
    numberImportAPort.title = @"A";
    
    [array addObject:numberImportRPort];
    [array addObject:numberImportGPort];
    [array addObject:numberImportBPort];
    [array addObject:numberImportAPort];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector4NodePortData *vectorExportNodeData = [[Vector4NodePortData alloc] init];
    vectorExportNodeData.title = @"Color";
    [array addObject:vectorExportNodeData];
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
    return [NSString stringWithFormat:@"gl_FragColor = vec4(%@); \n",
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName]];
}

- (NSString *)expressionRule
{
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "%@ \n"
                         "%@ \n"
                         "%@ \n"
                         "vec4 %@ = vec4(%@,%@,%@,%@);",
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
                         (
                          [[self.inPorts objectAtIndex:3] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:3] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:3] templateVariableDefaultValueExpressionRule]
                          ),
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:1] indexToVariableName],
                         [[self.inPorts objectAtIndex:2] indexToVariableName],
                         [[self.inPorts objectAtIndex:3] indexToVariableName]];
    return string;
}

@end
