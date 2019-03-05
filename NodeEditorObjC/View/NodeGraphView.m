//
//  NodeGraphView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphView.h"

@implementation NodeGraphView

- (void)reloadData
{
    //currently do nothing
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger nodeCount = [self.dataSource nodeCountInGraphView:self];
    NSLog(@"CURRENT NODE COUNT:%lu",(unsigned long)nodeCount);
    for (int i = 0; i < nodeCount; i ++ )
    {
        NodeView *nodeView = [self.dataSource nodeGraphView:self nodeForIndex:i];
        [self addSubview:nodeView];
        nodeView.frame = [self.visualDelegate nodeGraphView:self frameForIndex:i];
    }
}




@end
