//
//  NodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeData.h"

@implementation NodeData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self postInitWork];
    }
    return self;
}

- (void)postInitWork
{
    self.outPorts = [[self class] templateOutPorts];
    self.inPorts = [[self class] templateInPorts];
    self.coordinate = CGPointMake(0, 0);
    self.title = [[self class] templateTitle];
    self.size = [[self class] templateSize];
}

+ (NSString *)templateTitle;
{
    return @"Node Title";
}
+ (CGSize)templateSize
{
    return CGSizeMake(200, NODE_PADDING_HEIGHT * 2 + NODE_TITLE_HEIGHT + fmaxf([[self templateInPorts] count] * NODE_PORT_HEIGHT, [[self templateOutPorts] count] * NODE_PORT_HEIGHT));
}
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    return [NSMutableArray array];
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    return [NSMutableArray array];
}
- (void)breakConnections
{
    for (NodePortData *port in self.inPorts)
    {
        [port breakConnections];
    }
    for (NodePortData *port in self.outPorts)
    {
        [port breakConnections];
    }
}


@end
