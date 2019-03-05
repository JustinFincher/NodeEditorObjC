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
        self.title = @"Title Placeholder";
        self.outPorts = [NSMutableArray array];
        self.inPorts = [NSMutableArray array];
        self.coordinate = CGPointMake(0, 0);
        self.size = CGSizeMake(200, 360);
    }
    return self;
}

@end
