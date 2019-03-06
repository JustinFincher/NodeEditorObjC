//
//  NumberNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NumberNodeData.h"
#import "NumberNodePortData.h"

@implementation NumberNodeData

+ (NSString *)templateTitle
{
    return @"Number";
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
