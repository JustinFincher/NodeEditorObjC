//
//  NodeBoolean.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 10/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeBoolean.h"

@implementation NodeBoolean

- (instancetype)initWith:(BOOL)va
{
    self = [super init];
    if (self)
    {
        _value = [NSNumber numberWithBool:va];
    }
    return self;
}

@end
