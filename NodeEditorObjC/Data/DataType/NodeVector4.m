//
//  Vector4.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeVector4.h"

@implementation NodeVector4

- (instancetype)initWithX:(float)x
                        Y:(float)y
                        Z:(float)z
                        W:(float)w
{
    self = [super init];
    if (self)
    {
        _x = [NSNumber numberWithFloat:x];
        _y = [NSNumber numberWithFloat:y];
        _z = [NSNumber numberWithFloat:z];
        _w = [NSNumber numberWithFloat:w];
    }
    return self;
}
@end
