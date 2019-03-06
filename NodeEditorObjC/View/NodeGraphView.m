//
//  NodeGraphView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphView.h"
#import "NodeGraphScrollView.h"
#import "NodeGraphConnectionView.h"

@interface NodeGraphView()
@end

@implementation NodeGraphView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self postInitWork];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self postInitWork];
    }
    return self;
}

- (void)postInitWork
{
    self.nodeContainerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.nodeContainerView];
    
    self.nodeConnectionLineView = [[NodeGraphConnectionView alloc] initWithFrame:self.bounds];
    self.nodeConnectionLineView.graphView = self;
    [self addSubview:self.nodeConnectionLineView];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.nodeContainerView];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    self.dynamicItemBehavior.allowsRotation = NO;
    self.dynamicItemBehavior.friction = 1000;
    self.dynamicItemBehavior.elasticity = 0.9;
    self.dynamicItemBehavior.resistance = 0.6;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];
    
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}
- (void)addDynamicBehavior:(UIDynamicBehavior *)behavior
{
    [self.dynamicAnimator addBehavior:behavior];
}
- (void)removeDynamicBehavior:(UIDynamicBehavior *)behavior
{
    [self.dynamicAnimator removeBehavior:behavior];
}

- (void)reloadData
{
    //currently do nothing
    for (NodeView *nodeView in self.nodeContainerView.subviews)
    {
        [self.collisionBehavior removeItem:nodeView];
        [self.dynamicItemBehavior removeItem:nodeView];
        nodeView.nodeData.coordinate = nodeView.frame.origin;
        nodeView.nodeData.size = nodeView.frame.size;
        [nodeView removeFromSuperview];
    }
    NSUInteger nodeCount = [self.dataSource nodeCountInGraphView:self];
    for (int i = 0; i < nodeCount; i ++ )
    {
        NodeView *nodeView = [self.dataSource nodeGraphView:self nodeForIndex:[[NSNumber numberWithInteger:i]stringValue]];
        [self.nodeContainerView addSubview:nodeView];
        nodeView.nodeGraphView = self;
        nodeView.frame = [self.visualDelegate nodeGraphView:self frameForIndex:[[NSNumber numberWithInteger:i]stringValue]];
        [self.parentScrollView.panGestureRecognizer requireGestureRecognizerToFail:nodeView.panGestureRecognizer];
        [self.parentScrollView.panGestureRecognizer requireGestureRecognizerToFail:nodeView.longPressGestureRecognizer];
        [self.parentScrollView.pinchGestureRecognizer requireGestureRecognizerToFail:nodeView.panGestureRecognizer];
        [self.parentScrollView.pinchGestureRecognizer requireGestureRecognizerToFail:nodeView.longPressGestureRecognizer];
        
        [self.dynamicItemBehavior addItem:nodeView];
        [self.collisionBehavior addItem:nodeView];
    }
}
#pragma mark - UIDynamicAnimatorDelegate

@end
