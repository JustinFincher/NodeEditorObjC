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
    self.isFocused = false;
}
- (void)setIsFocused:(BOOL)isFocused
{
    if (_isFocused != isFocused && self.isFocusedChangedBlock)
    {
        _isFocused = isFocused;
        self.isFocusedChangedBlock(isFocused);
    }
    else
    {
        _isFocused = isFocused;
    }
}
- (CGRect)getRecordedFrame
{
    return CGRectMake(self.coordinate.x, self.coordinate.y, self.size.width, self.size.height);
}
- (void)setNodeIndex:(NSString *)index
{
    _nodeIndex = index;
    NSLog(@"SET %@ INDEX = %@",self,index);
    int i = 0;
    for (NodePortData *port in self.inPorts)
    {
        port.belongsToNode = self;
        port.portIndex = [NSString stringWithFormat:@"%@-%@",index,[[NSNumber numberWithInteger:i] stringValue]];
        NSLog(@"SET %@ INDEX = %@",port,port.portIndex);
        i ++;
    }
    for (NodePortData *port in self.outPorts)
    {
        port.belongsToNode = self;
        port.portIndex = [NSString stringWithFormat:@"%@-%@",index,[[NSNumber numberWithInteger:i] stringValue]];
        NSLog(@"SET %@ INDEX = %@",port,port.portIndex);
        i ++;
    }
    
}

+ (NSString *)templateTitle;
{
    return @"Node Title";
}
+ (CGSize)templateSize
{
    return CGSizeMake(NODE_WIDTH, NODE_PADDING_HEIGHT * 2 + NODE_TITLE_HEIGHT + fmaxf([[self templateInPorts] count] * NODE_PORT_HEIGHT, [[self templateOutPorts] count] * NODE_PORT_HEIGHT));
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

- (void)prepareForDealloc
{
    for (NodePortData *port in self.inPorts)
    {
        port.belongsToNode = nil;
    }
    for (NodePortData *port in self.outPorts)
    {
        port.belongsToNode = nil;
    }
    [self.inPorts removeAllObjects];
    [self.outPorts removeAllObjects];
}
/**
 Add this because we need two way strong reference (node <--> port). Hmmm not a good practice but needed for now
 */
- (void)dealloc
{
    [self prepareForDealloc];
}
@end
