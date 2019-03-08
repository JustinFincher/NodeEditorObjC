//
//  Vector2ChannelSplitNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector2ChannelSplitNodeData.h"
#import "Vector2NodePortData.h"
#import "NumberFloatNodePortData.h"

@implementation Vector2ChannelSplitNodeData


+ (NSString *)templateTitle
{
    return @"Split (Vector2 to Float)";
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
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
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector2NodePortData *vector2Port = [[Vector2NodePortData alloc] init];
    vector2Port.title = @"Vector";
    [array addObject:vector2Port];
    return array;
}

+ (BOOL)templateCanHavePreview
{
    return NO;
}
+ (int)templatePreviewForOutPortIndex
{
    return -1;
}

- (NSString *)expressionRule
{
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "float %@ = %@.x;"
                         "float %@ = %@.y;",
                         [self nodeCommentHeader],
                         (
                          [[self.inPorts objectAtIndex:0] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:0] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:0] templateVariableDefaultValueExpressionRule]
                          ),
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.outPorts objectAtIndex:1] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName]];
    return string;
}


@end
