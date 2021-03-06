//
//  TimeNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "TimeNodeData.h"
#import "NumberFloatNodePortData.h"

@implementation TimeNodeData

+ (NSString *)templateTitle
{
    return @"Time (u_time)";
}

+ (BOOL)templateCanHavePreview
{
    return NO;
}
+ (int)templatePreviewForOutPortIndex
{
    return -1;
}

+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberExportPort = [[NumberFloatNodePortData alloc] init];
    numberExportPort.title = @"Value";
    [array addObject:numberExportPort];
    return array;
}

- (NSString *)expressionRule
{
    NodePortData *timePortData = [self.outPorts objectAtIndex:0];
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         @"float %@ = u_time;",
                         [self nodeCommentHeader],
                         [timePortData indexToVariableName]];
    return string;
}
@end
