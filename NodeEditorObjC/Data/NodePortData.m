//
//  NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortData.h"
#import "NodeConnectionData.h"

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
@end
