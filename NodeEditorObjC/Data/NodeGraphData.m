//
//  NodeGraphData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphData.h"
#import "NodeConnectionData.h"

@implementation NodeGraphData

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.singleNodes = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Graph Methods
- (BOOL)canConnectFrom:(NodePortData *)nodePortOut To:(NodePortData *)nodePortIn
{
    return YES;
}

- (BOOL)connectFrom:(NodePortData *)nodePortOut To:(NodePortData *)nodePortIn
{
    return YES;
}
- (NSUInteger)getNodeTotalCount
{
    return [[self getIndexNodeDict] count];
}
- (NodeData *)getNodeWithIndex:(NSUInteger)index
{
    return [[self getIndexNodeDict] objectForKey:[NSNumber numberWithInteger:index]];
}

- (NSDictionary<NSNumber *,NodeData *> *)getIndexNodeDict
{
    NSMutableDictionary<NSNumber *,NodeData *> *dictionary = [NSMutableDictionary dictionary];
    for (NodeData *finalNode in self.singleNodes)
    {
        [self DFS:finalNode withDict:dictionary];
    }
    
    //
    for (NSNumber *num in dictionary.allKeys)
    {
        NSLog(@"KEY:%ld VALUE:%@",(long)[num integerValue],[dictionary objectForKey:num]);
    }
    
    return [dictionary copy];
}

- (void)DFS:(NodeData *)node withDict:(NSMutableDictionary<NSNumber *,NodeData *> *)dict
{
//    NSLog(@"DFS NODE %@",node);
    if (node != nil && ![dict.allValues containsObject:node])
    {
        [dict setObject:node forKey:[NSNumber numberWithInteger:node.index]];
    }
    
    
    for (NodePortData *nodePort in node.inPorts)
    {
        for (NodeConnectionData *connection in nodePort.connections)
        {
            [self DFS:connection.inPort.belongsToNode withDict:dict];
        }
    }
}

- (BOOL)addNode:(NodeData *)node
{
    if ([self.singleNodes containsObject:node])
    {
        NSLog(@"NODE %@ ALREADY ADDED TO NODE GRAPH %@, NO",node,self);
        return NO;
    }
    node.index = self.singleNodes.count;
    [self.singleNodes addObject:node];
    NSLog(@"NODE %@ ADDED TO NODE GRAPH %@, YES",node,self);
    return YES;
}

- (BOOL)removeNode:(NodeData *)node
{
    if (![self getNodeWithIndex:node.index])
    {
        NSLog(@"NODE %@ NOT ADDED TO NODE GRAPH %@, NO",node,self);
        return NO;
    }
    if ([self.singleNodes containsObject:node])
    {
        [self.singleNodes removeObject:node];
    }else
    {
        [node breakConnections];
    }
    return YES;
}
@end
