//
//  NodeConnectionData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeConnectionData.h"
#import "NodePortData.h"

@implementation NodeConnectionData

- (NSString *)expressionRule
{
    return  [NSString stringWithFormat:@"%@ %@ = %@;",
            [self.outport requiredCgType],
            [self.outport indexToVariableName],
            [self.inPort indexToVariableName]];
}

@end
