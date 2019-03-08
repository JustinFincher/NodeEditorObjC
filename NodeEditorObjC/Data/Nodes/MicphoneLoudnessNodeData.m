//
//  MicphoneLoudnessNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 7/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "MicphoneLoudnessNodeData.h"
#import "NumberFloatNodePortData.h"

@implementation MicphoneLoudnessNodeData

+ (NSString *)templateTitle
{
    return @"Micphone Loudness";
}

+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberExportPort = [[NumberFloatNodePortData alloc] init];
    numberExportPort.title = @"Value";
    [array addObject:numberExportPort];
    return array;
}

@end