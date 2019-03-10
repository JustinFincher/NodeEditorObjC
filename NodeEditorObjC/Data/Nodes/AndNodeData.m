//
//  AndNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 10/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "AndNodeData.h"
#import "BoolNodePortData.h"

@implementation AndNodeData

+ (NSString *)templateTitle
{
    return @"And (&&)";
}

+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    
    BoolNodePortData *numberImportAPort = [[BoolNodePortData alloc] init];
    numberImportAPort.title = @"A";
    
    BoolNodePortData *numberImportBPort = [[BoolNodePortData alloc] init];
    numberImportBPort.title = @"B";
    
    [array addObject:numberImportAPort];
    [array addObject:numberImportBPort];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    
    BoolNodePortData *bigBoolNodePortData = [[BoolNodePortData alloc] init];
    bigBoolNodePortData.title = @"A && B";
    [array addObject:bigBoolNodePortData];
    
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
                         "%@ \n"
                         "bool %@ = (%@ == %@);",
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
