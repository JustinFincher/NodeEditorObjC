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
#import "NodePortView.h"

@interface NodeGraphView()

@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecoginzer;
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
    __weak __typeof(self)weakSelf= self;
    
    self.nodeContainerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.nodeContainerView];
    
    self.nodeConnectionLineView = [[NodeGraphConnectionView alloc] initWithFrame:self.bounds nodeGraphView:self];
    [self addSubview:self.nodeConnectionLineView];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.nodeContainerView];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    self.dynamicItemBehavior.allowsRotation = NO;
    self.dynamicItemBehavior.friction = 1000;
    self.dynamicItemBehavior.elasticity = 0.9;
    self.dynamicItemBehavior.resistance = 0.6;
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];
    self.dynamicItemBehavior.action = ^(){
        for (NodeView *nodeView in weakSelf.nodeContainerView.subviews)
        {
            [nodeView updateSelfInAnimator];
        }
    };
    
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    self.collisionBehavior.action = ^(){
        for (NodeView *nodeView in weakSelf.nodeContainerView.subviews)
        {
            [nodeView updateSelfInAnimator];
        }
    };
    
    self.longPressGestureRecoginzer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.nodeContainerView addGestureRecognizer:self.longPressGestureRecoginzer];
    
    
}
- (void)addDynamicBehavior:(UIDynamicBehavior *)behavior
{
    [self.dynamicAnimator addBehavior:behavior];
}
- (void)removeDynamicBehavior:(UIDynamicBehavior *)behavior
{
    [self.dynamicAnimator removeBehavior:behavior];
}

- (void)updateFocusState:(NodeData *)nodeData
{
    [[self.dataSource getIndexNodeDict] enumerateKeysAndObjectsUsingBlock:^(NSString *key,NodeData *value,BOOL *stop)
    {
        value.isFocused = (nodeData.nodeIndex == value.nodeIndex);
    }];
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
        nodeView.frame = [self.visualDelegate nodeGraphView:self frameForIndex:[[NSNumber numberWithInteger:i]stringValue]];
        nodeView.makeFocusBlock = ^(NodeData *newFocusedData)
        {
            [self updateFocusState:newFocusedData];
        };
        [self.parentScrollView.panGestureRecognizer requireGestureRecognizerToFail:nodeView.panGestureRecognizer];
        [self.parentScrollView.panGestureRecognizer requireGestureRecognizerToFail:nodeView.longPressGestureRecognizer];
        [self.parentScrollView.pinchGestureRecognizer requireGestureRecognizerToFail:nodeView.panGestureRecognizer];
        [self.parentScrollView.pinchGestureRecognizer requireGestureRecognizerToFail:nodeView.longPressGestureRecognizer];
        [self.longPressGestureRecoginzer requireGestureRecognizerToFail:nodeView.panGestureRecognizer];
        [self.longPressGestureRecoginzer requireGestureRecognizerToFail:nodeView.longPressGestureRecognizer];
        
        [self.dynamicItemBehavior addItem:nodeView];
        [self.collisionBehavior addItem:nodeView];
    }
    [self.nodeConnectionLineView setNeedsDisplay];
}
#pragma mark - Gesture
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.nodeContainerView];
    NSDictionary *userInfo  = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:point] forKey:@"point"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHOW_NODE_LIST object:self.nodeContainerView userInfo:userInfo];
}
- (void)handleKnotPanGesture:(UIPanGestureRecognizer *)gesture
{
    NodePortView *portView = [NodePortView getNodePortFromKnotView:(NodePortKnotView *)gesture.view];
    if (portView)
    {
        NSLog(@"%@",portView);
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
            case UIGestureRecognizerStateChanged:
            {
                [self.connectionVisualDelegate currentPointAt:[gesture locationInView:self.nodeContainerView] dragging:YES from:portView];
            }
                break;
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
            {
                [self.connectionVisualDelegate currentPointAt:[gesture locationInView:self.nodeContainerView] dragging:NO from:nil];
            }
                break;
            case UIGestureRecognizerStateEnded:
            {
                [self.connectionVisualDelegate currentPointAt:[gesture locationInView:self.nodeContainerView] dragging:NO from:nil];
                NodePortView *anotherPortView = [self.dataSource portViewFrom:[gesture locationInView:self.nodeContainerView]];
                if
                    ([portView.nodePortData isInPortRelativeToConnection] &&
                     [anotherPortView.nodePortData isOutPortRelativeToConnection] &&
                     [self.dataSource canConnectOutPort:portView.nodePortData withInPort:anotherPortView.nodePortData])
                {
                    [self.dataSource connectOutPort:portView.nodePortData withInPort:anotherPortView.nodePortData];                    [self reloadData];
                }else if
                    ([portView.nodePortData isOutPortRelativeToConnection] &&
                     [anotherPortView.nodePortData isInPortRelativeToConnection] &&
                     [self.dataSource canConnectOutPort:anotherPortView.nodePortData withInPort:portView.nodePortData])
                {
                    [self.dataSource connectOutPort:anotherPortView.nodePortData withInPort:portView.nodePortData];
                    [self reloadData];
                }
            }
                break;
            case UIGestureRecognizerStatePossible:
            {}
                break;
        }
    }
}
@end
