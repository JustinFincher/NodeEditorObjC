//
//  NodeGraphEditorViewController.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphEditorViewController.h"


@interface NodeGraphEditorViewController ()<NodeGraphViewDataSource,NodeGraphViewVisualDelegate>

@end

@implementation NodeGraphEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Node Editor";
    
    self.nodeGraphData = [[NodeGraphData alloc] init];
    self.nodeGraphScrollView.nodeGraphView.dataSource = self;
    self.nodeGraphScrollView.nodeGraphView.visualDelegate = self;
    
    // Test
    NodeData *initalNodeData = [[NodeData alloc] init];
    [self.nodeGraphData addNode:initalNodeData];
    NodeData *inital2NodeData = [[NodeData alloc] init];
    [self.nodeGraphData addNode:inital2NodeData];
    
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}

#pragma mark - NodeGraphViewDataSource

- (NodeView *)nodeGraphView:(NodeGraphView *)graphView nodeForIndex:(NSUInteger)index
{
    NodeView *node = [[NodeView alloc] init];
    node.nodeData = [self.nodeGraphData getNodeWithIndex:index];
    return node;
}
- (NSUInteger)nodeCountInGraphView:(NodeGraphView *)graphView
{
    return [self.nodeGraphData getNodeTotalCount];
}

#pragma mark - NodeGraphViewVisualDelegate

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSUInteger)index
{
    CGPoint coordinate = [[self.nodeGraphData getNodeWithIndex:index] coordinate];
    CGSize size = [[self.nodeGraphData getNodeWithIndex:index] size];
    return CGRectMake(coordinate.x, coordinate.y, size.width, size.height);
}

@end
