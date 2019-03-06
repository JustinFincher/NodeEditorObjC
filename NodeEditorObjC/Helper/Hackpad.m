//
//  Hackpad.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Hackpad.h"

#import "AddNodeData.h"
#import "NumberNodeData.h"

#import "NodeGraphData.h"
#import "NodeConnectionData.h"

@implementation Hackpad

+ (id)sharedManager {
    static Hackpad *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)testNodeOn:(NodeGraphEditorViewController *)viewController
{
    AddNodeData *addNode = [[AddNodeData alloc] init];
    [viewController.nodeGraphData addNode:addNode];
    NumberNodeData *numberANode = [[NumberNodeData alloc] init];
    [viewController.nodeGraphData addNode:numberANode];
    
    [viewController.nodeGraphData connectOutPort:[numberANode.outPorts objectAtIndex:0] withInPort:[addNode.inPorts objectAtIndex:0]];
}

@end
