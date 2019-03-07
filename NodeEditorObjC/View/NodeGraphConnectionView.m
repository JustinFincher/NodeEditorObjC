//
//  NodeGraphConnectionView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphConnectionView.h"
#import "NodePortView.h"
@interface NodeGraphConnectionView()<NodeGraphViewConnectionVisualDelegate>

@property (nonatomic) BOOL isDragging;
@property (nonatomic) CGPoint currentPosition;

@end

@implementation NodeGraphConnectionView
#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){[self postInitWork];}
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){[self postInitWork];}
    return self;
}

- (void)postInitWork
{
    self.userInteractionEnabled = YES;
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.nodeGraphView.connectionVisualDelegate = self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    return nil;
}
- (void)drawRect:(CGRect)rect
{
    if (self.nodeGraphView && self.nodeGraphView.dataSource)
    {
        NSUInteger count = [self.nodeGraphView.dataSource nodeCountInGraphView:self.nodeGraphView];
        //NSLog(@"COUNT = %lu",(unsigned long)count);
        for (int i = 0; i < count; i ++)
        {
            NodeData *inNodeData = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeDataForIndex:[[NSNumber numberWithInteger:i]stringValue]];
            NodeView *inNodeView = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeForIndex:[[NSNumber numberWithInteger:i]stringValue]];
            
            for (NodePortData *port in inNodeData.inPorts)
            {
                for (NodeConnectionData *connection in port.connections)
                {
                    NodeView *outNodeView = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeForIndex:connection.inPort.belongsToNode.nodeIndex];
                    NodeData *outNodeData = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeDataForIndex:connection.inPort.belongsToNode.nodeIndex];

                    NodePortView *outNodePortView = [[outNodeView.ports filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodePortData.portIndex == %@",connection.inPort.portIndex]] firstObject];
                    NodePortView *inNodePortView = [[inNodeView.ports filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodePortData.portIndex == %@",connection.outport.portIndex]] firstObject];
                    
                    CGPoint outNodePoint = CGPointMake(
                                                       [outNodeView convertRect:outNodePortView.knotIndicator.bounds fromView:outNodePortView.knotIndicator].origin.x + outNodePortView.knotIndicator.bounds.size.width / 2 + outNodeData.coordinate.x,
                                                       [outNodeView convertRect:outNodePortView.knotIndicator.bounds fromView:outNodePortView.knotIndicator].origin.y + outNodePortView.knotIndicator.bounds.size.height / 2 + outNodeData.coordinate.y);
                    
                    CGPoint inNodePoint = CGPointMake(
                                                      [inNodeView convertRect:inNodePortView.knotIndicator.bounds fromView:inNodePortView.knotIndicator].origin.x + inNodePortView.knotIndicator.bounds.size.width / 2 + inNodeData.coordinate.x,
                                                      [inNodeView convertRect:inNodePortView.knotIndicator.bounds fromView:inNodePortView.knotIndicator].origin.y + inNodePortView.knotIndicator.bounds.size.height / 2 + inNodeData.coordinate.y);
                    UIColor *color = [[UIColor redColor] colorWithAlphaComponent:0.5f];
                    [color set];
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:outNodePoint];
                    [path addCurveToPoint:inNodePoint controlPoint1:CGPointMake(outNodePoint.x + NODE_CONNECTION_CURVE_CONTROL_OFFSET, outNodePoint.y) controlPoint2:CGPointMake(inNodePoint.x - NODE_CONNECTION_CURVE_CONTROL_OFFSET, inNodePoint.y)];
                    path.lineWidth = 5.0;
                    path.lineCapStyle = kCGLineCapRound; //线条拐角
                    path.lineJoinStyle = kCGLineJoinRound; //终点处理
                    [path stroke];

                }
            }
        }
    }
}

#pragma mark - NodeGraphViewConnectionVisualDelegate
-  (void)currentPointAt:(CGPoint)endPosition
               dragging:(BOOL)isDragging
                   from:(NodePortData *)port
{
    
}

@end
