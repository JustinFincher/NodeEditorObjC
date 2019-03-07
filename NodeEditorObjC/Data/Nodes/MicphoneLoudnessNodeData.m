//
//  MicphoneLoudnessNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 7/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "MicphoneLoudnessNodeData.h"
#import "NumberNodePortData.h"

@implementation MicphoneLoudnessNodeData

+ (NSString *)templateTitle
{
    return @"Micphone Loudness";
}

+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberNodePortData *numberExportPort = [[NumberNodePortData alloc] init];
    numberExportPort.title = @"Value";
    [array addObject:numberExportPort];
    return array;
}

@end
