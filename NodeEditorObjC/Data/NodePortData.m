//
//  NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortData.h"
#import "NodeConnectionData.h"
#import "NodeData.h"

@implementation NodePortData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = [[self class] templateTitle];
        self.connections = [NSMutableOrderedSet orderedSet];
        self.requiredType = [[self class] templateRequiredType];
    }
    return self;
}

+ (NSString *)templateTitle
{
    return @"Port Title";
}

+ (Class) templateRequiredType
{
    return [NSObject class];
}

- (void)setBelongsToNode:(NodeData *)belongsToNode
{
    _belongsToNode = belongsToNode;
    //NSLog(@"SET %@.belongsToNode = %@",self,belongsToNode);
}

- (void)breakConnections
{
    for (NodeConnectionData *connection in self.connections)
    {
        if (connection.inPort != self)
        {
            [connection.inPort.connections removeObject:connection];
        }
        
        if (connection.outport != self)
        {
            [connection.outport.connections removeObject:connection];
        }
    }
}

- (BOOL)isInPortRelativeToNode
{
    return [self.belongsToNode.inPorts containsObject:self];
}
- (BOOL)isOutPortRelativeToNode
{
    return [self.belongsToNode.outPorts containsObject:self];
}
- (BOOL)isInPortRelativeToConnection
{
    return [self isOutPortRelativeToNode];
}
- (BOOL)isOutPortRelativeToConnection
{
    return [self isInPortRelativeToNode];
}

- (NSString *)indexToVariableName
{
    return [NSString stringWithFormat:@"var_%@",[self.portIndex stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
}
@end
