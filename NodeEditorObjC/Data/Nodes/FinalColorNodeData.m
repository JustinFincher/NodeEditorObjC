//
//  FinalColorNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "FinalColorNodeData.h"
#import "NumberFloatNodePortData.h"
#import "Vector4NodePortData.h"

@implementation FinalColorNodeData

+ (NSString *)templateTitle
{
    return @"Color RGBA";
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

- (NSString *)expressionRule
{
    
    NSMutableOrderedSet *rConnectionSet = [[self.inPorts objectAtIndex:0] connections];
    NSString *declareR = [NSString stringWithFormat:
                          @"float %@ = %@;",
                          rConnectionSet.count > 0 ? [[[rConnectionSet firstObject] outport] indexToVariableName] : [[self.inPorts objectAtIndex:0] indexToVariableName],
                          rConnectionSet.count > 0 ? [[[rConnectionSet firstObject] inPort] indexToVariableName] : [NSString stringWithFormat:@"%.8f",0.0f]];
    
    NSMutableOrderedSet *gConnectionSet = [[self.inPorts objectAtIndex:1] connections];
    NSString *declareG = [NSString stringWithFormat:
                          @"float %@ = %@;",
                          gConnectionSet.count > 0 ? [[[gConnectionSet firstObject] outport] indexToVariableName] : [[self.inPorts objectAtIndex:1] indexToVariableName],
                          gConnectionSet.count > 0 ? [[[gConnectionSet firstObject] inPort] indexToVariableName] : [NSString stringWithFormat:@"%.8f",0.0f]];
    
    NSMutableOrderedSet *bConnectionSet = [[self.inPorts objectAtIndex:2] connections];
    NSString *declareB = [NSString stringWithFormat:
                          @"float %@ = %@;",
                          bConnectionSet.count > 0 ? [[[bConnectionSet firstObject] outport] indexToVariableName] : [[self.inPorts objectAtIndex:2] indexToVariableName],
                          bConnectionSet.count > 0 ? [[[bConnectionSet firstObject] inPort] indexToVariableName] : [NSString stringWithFormat:@"%.8f",0.0f]];
    
    NSMutableOrderedSet *aConnectionSet = [[self.inPorts objectAtIndex:3] connections];
    NSString *declareA = [NSString stringWithFormat:
                          @"float %@ = %@;",
                          aConnectionSet.count > 0 ? [[[aConnectionSet firstObject] outport] indexToVariableName] : [[self.inPorts objectAtIndex:3] indexToVariableName],
                          aConnectionSet.count > 0 ? [[[aConnectionSet firstObject] inPort] indexToVariableName] : [NSString stringWithFormat:@"%.8f",0.0f]];
    
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "%@ \n"
                         "%@ \n"
                         "%@ \n"
                         "vec4 %@ = vec4(%@,%@,%@,%@);",
                         [self nodeCommentHeader],
                         declareR,
                         declareG,
                         declareB,
                         declareA,
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:1] indexToVariableName],
                         [[self.inPorts objectAtIndex:2] indexToVariableName],
                         [[self.inPorts objectAtIndex:3] indexToVariableName]];
    return string;
}

@end
