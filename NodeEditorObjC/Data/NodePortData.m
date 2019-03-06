//
//  NodePortData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortData.h"

@implementation NodePortData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.portName = @"Port Title";
        self.connections = [NSMutableSet set];
        self.requiredType = [NSObject class];
    }
    return self;
}

@end
