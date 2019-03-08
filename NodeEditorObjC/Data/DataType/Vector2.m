//
//  Vector2.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Vector2.h"

@implementation Vector2

- (instancetype)initWithX:(float)x
                        Y:(float)y
{
    self = [super init];
    if (self)
    {
        _x = [NSNumber numberWithFloat:x];
        _y = [NSNumber numberWithFloat:y];
    }
    return self;
}

@end
