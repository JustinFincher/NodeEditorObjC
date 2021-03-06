//
//  Vector2ChannelCombineNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector2ChannelCombineNodeData.h"
#import "Vector2NodePortData.h"
#import "NumberFloatNodePortData.h"

@implementation Vector2ChannelCombineNodeData

+ (NSString *)templateTitle
{
    return @"Combine (Floatt to Vector2)";
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector2NodePortData *vector2Port = [[Vector2NodePortData alloc] init];
    vector2Port.title = @"Vector";
    [array addObject:vector2Port];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberAPort = [[NumberFloatNodePortData alloc] init];
    numberAPort.title = @"X";
    [array addObject:numberAPort];
    NumberFloatNodePortData *numberBPort = [[NumberFloatNodePortData alloc] init];
    numberBPort.title = @"Y";
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
    return [NSString stringWithFormat:@"gl_FragColor = vec4(%@,%.8f,%.8f); \n",
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
            [@0 floatValue],
            [@0 floatValue]];
}
- (NSString *)expressionRule
{
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "%@ \n"
                         "vec2 %@ = vec2(%@,%@);",
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
