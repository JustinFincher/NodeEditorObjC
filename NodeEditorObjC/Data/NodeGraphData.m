//
//  NodeGraphData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphData.h"
#import "NodeConnectionData.h"

@interface NodeGraphData()

@property (nonatomic,strong) NSMutableDictionary<NSString *,NodeData *> *cachedDictionary;
@property (nonatomic) BOOL useCache;

@end
@implementation NodeGraphData

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.singleNodes = [NSMutableOrderedSet orderedSet];
        self.useCache = NO;
    }
    return self;
}

#pragma mark - Graph Methods
- (NSUInteger)getNodeTotalCount
{
    return [[self getIndexNodeDict] count];
}
- (NodeData *)getNodeWithIndex:(NSString *)index
{
    return [[self getIndexNodeDict] objectForKey:index];
}

- (NSDictionary<NSString *,NodeData *> *)getIndexNodeDict
{
    if (!self.useCache || !self.cachedDictionary)
    {
        self.cachedDictionary = [NSMutableDictionary dictionary];
        for (NodeData *finalNode in self.singleNodes)
        {
            [self DFS:finalNode withDict:self.cachedDictionary];
        }
    }
    return self.cachedDictionary;
}

- (void)DFS:(NodeData *)node withDict:(NSMutableDictionary<NSString *,NodeData *> *)dict
{
//    NSLog(@"DFS NODE %@ INDEX %@",node,node.nodeIndex);
    if (node != nil && ![dict.allValues containsObject:node])
    {
        [dict setObject:node forKey:node.nodeIndex];
        for (NodePortData *nodePort in node.inPorts)
        {
            for (NodeConnectionData *connection in nodePort.connections)
            {
                [self DFS:connection.inPort.belongsToNode withDict:dict];
            }
        }
    }
}

- (BOOL)addNode:(NodeData *)node
{
    if ([self.singleNodes filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodeIndex == %@", node.nodeIndex]].count > 0)
    {
        NSLog(@"NODE %@ ALREADY ADDED TO NODE GRAPH %@, NO, INDEX = %@",node,self,node.nodeIndex);
        return NO;
    }
    node.nodeIndex = [[NSNumber numberWithInteger:self.singleNodes.count] stringValue];
    [self.singleNodes addObject:node];
    NSLog(@"NODE %@ ADDED TO NODE GRAPH %@, YES, INDEX = %@",node,self,node.nodeIndex);
    self.cachedDictionary = nil;
    return YES;
}

- (BOOL)removeNode:(NodeData *)node
{
    if (![self getNodeWithIndex:node.nodeIndex])
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
    for (NodePortData *portData in node.inPorts)
    {
        for (NodeConnectionData *connection in portData.connections)
        {
            [self.singleNodes addObject:connection.inPort.belongsToNode];
        }
    }
    [node prepareForDealloc];
    self.cachedDictionary = nil;
    return YES;
}
- (void)connectOutPort:(NodePortData *)outPort
            withInPort:(NodePortData *)inPort
{
    NodeConnectionData *connection = [[NodeConnectionData alloc] init];
    connection.inPort = outPort;
    connection.outport = inPort;
    [outPort.connections addObject:connection];
    [inPort.connections addObject:connection];
    
    if ([self.singleNodes containsObject:outPort.belongsToNode])
    {
        NodeData *node = outPort.belongsToNode;
        [self.singleNodes removeObject:node];
        inPort.connections.lastObject.inPort.belongsToNode = node;
    }
    
    //NSLog(@"%@",[inPort.connections lastObject].inPort);
    
    self.cachedDictionary = nil;
    
}
@end
