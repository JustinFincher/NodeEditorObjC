//
//  AddNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "AddNodeData.h"
#import "NumberNodePortData.h"

@implementation AddNodeData

+ (NSString *)templateTitle
{
    return @"Add";
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberNodePortData *numberExportPort = [[NumberNodePortData alloc] init];
    numberExportPort.title = @"Result";
    [array addObject:numberExportPort];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberNodePortData *numberAPort = [[NumberNodePortData alloc] init];
    numberAPort.title = @"A";
    [array addObject:numberAPort];
    NumberNodePortData *numberBPort = [[NumberNodePortData alloc] init];
    numberBPort.title = @"B";
    [array addObject:numberBPort];
    return array;
}
@end
