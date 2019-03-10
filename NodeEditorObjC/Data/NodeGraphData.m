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

@end
@implementation NodeGraphData

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.singleNodes = [NSMutableOrderedSet orderedSet];
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_SHADER_MODIFIED object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif)
        {
            [self updateNodeShaders];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHADER_VIEW_NEED_RELOAD object:nil];
        }];
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
- (void)updateNodeShaders
{
    for (NodeData *finalNode in self.singleNodes)
    {
        NSMutableDictionary<NSString *,NSMutableArray<NSString *>*> *programDict = [[NSMutableDictionary alloc] init];
        
        [self DFS:finalNode shaderDict:programDict];
        
        [programDict enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSMutableArray<NSString *> *array, BOOL *stop)
        {
            NodeData *nodeData = [self.cachedDictionary objectForKey:key];
            if ([[nodeData class] templateCanHavePreview])
            {
                nodeData.shaderProgram = [array componentsJoinedByString:@"\n"];
            }
        }];
    }
}
- (void)updateNodeRelations
{
    self.cachedDictionary = [NSMutableDictionary dictionary];
    for (NodeData *finalNode in self.singleNodes)
    {
        [self DFS:finalNode withIndexDict:self.cachedDictionary];
    }
}

- (NSDictionary<NSString *,NodeData *> *)getIndexNodeDict
{
    if (!self.cachedDictionary)
    {
        [self updateNodeRelations];
        [self updateNodeShaders];
    }
    return self.cachedDictionary;
}

- (void)DFS:(NodeData *)node
 shaderDict:(NSMutableDictionary<NSString *,NSMutableArray<NSString *>*>*)shaderDict
{
    if (node != nil)
    {
        [shaderDict setObject:[NSMutableArray array] forKey:node.nodeIndex];
        [shaderDict enumerateKeysAndObjectsUsingBlock:^(NSString *key,NSMutableArray<NSString *> *array, BOOL *stop)
        {
            if ([array containsObject:node.expressionRule])
            {
                [array removeObject:node.expressionRule];
            }
            [array insertObject:node.expressionRule atIndex:0];
        }];
        for (NodePortData *nodePort in node.inPorts)
        {
            for (NodeConnectionData *connection in nodePort.connections)
            {
                [self DFS:connection.inPort.belongsToNode shaderDict:shaderDict];
            }
        }
    }
}

- (void)DFS:(NodeData *)node
withIndexDict:(NSMutableDictionary<NSString *,NodeData *> *)dict;
{
    if (node != nil)
    {
        // re-issue ID
        if (![[dict allValues] containsObject:node])
        {
            node.nodeIndex = [[NSNumber numberWithInteger:[dict count]] stringValue];
            [dict setObject:node forKey:node.nodeIndex];
        }
        
        for (NodePortData *nodePort in node.inPorts)
        {
            for (NodeConnectionData *connection in nodePort.connections)
            {
                [self DFS:connection.inPort.belongsToNode withIndexDict:dict];
            }
        }
    }
}

- (BOOL)isSingleNode:(NodeData *)node
{
    return [self.singleNodes containsObject:node];
}

- (BOOL)addNode:(NodeData *)node
{
    if ([self.singleNodes filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodeIndex == %@", node.nodeIndex]].count > 0)
    {
        NSLog(@"NODE %@ ALREADY ADDED TO NODE GRAPH %@, NO, INDEX = %@",node,self,node.nodeIndex);
        return NO;
    }
    node.nodeIndex = [[NSNumber numberWithInteger:[[self getIndexNodeDict] count]] stringValue];
    [self.singleNodes addObject:node];
    self.cachedDictionary = nil;
    self.graphChangedBlock();
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
    }
    [node breakConnections];
    for (NodePortData *portData in node.inPorts)
    {
        for (NodeConnectionData *connection in portData.connections)
        {
            [self.singleNodes addObject:connection.inPort.belongsToNode];
        }
    }
    [node prepareForDealloc];
    self.cachedDictionary = nil;
    self.graphChangedBlock();
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
    self.cachedDictionary = nil;
    self.graphChangedBlock();
}

- (BOOL)canConnectOutPort:(NodePortData *)outPort withInPort:(NodePortData *)inPort
{
    return (
            [outPort isOutPortRelativeToNode] &&
            [inPort isInPortRelativeToNode] &&
            [[inPort connections] count] == 0 &&
            outPort.belongsToNode.nodeIndex != inPort.belongsToNode.nodeIndex &&
            [outPort requiredType] == [inPort requiredType]
            );
}
- (void)disconnectConnection:(NodeConnectionData *)connection
{
    NodePortData *inPort = connection.inPort;
    NodePortData *outPort = connection.outport;
    [inPort.connections removeObject:connection];
    [outPort.connections removeObject:connection];
    [self.singleNodes addObject:inPort.belongsToNode];
    self.cachedDictionary = nil;
    self.graphChangedBlock();
}
@end
