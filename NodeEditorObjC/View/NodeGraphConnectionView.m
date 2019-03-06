//
//  NodeGraphConnectionView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphConnectionView.h"
#import "NodePortView.h"

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
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    return nil;
}
- (void)drawRect:(CGRect)rect
{
    if (self.graphView && self.graphView.dataSource)
    {
        NSUInteger count = [self.graphView.dataSource nodeCountInGraphView:self.graphView];
        //NSLog(@"COUNT = %lu",(unsigned long)count);
        for (int i = 0; i < count; i ++)
        {
            NodeData *inNodeData = [self.graphView.dataSource nodeGraphView:self.graphView nodeDataForIndex:[[NSNumber numberWithInteger:i]stringValue]];
            NodeView *inNodeView = [self.graphView.dataSource nodeGraphView:self.graphView nodeForIndex:[[NSNumber numberWithInteger:i]stringValue]];
            
            for (NodePortData *port in inNodeData.inPorts)
            {
                for (NodeConnectionData *connection in port.connections)
                {
                    NodeView *outNodeView = [self.graphView.dataSource nodeGraphView:self.graphView nodeForIndex:connection.inPort.belongsToNode.nodeIndex];
                    NodeData *outNodeData = [self.graphView.dataSource nodeGraphView:self.graphView nodeDataForIndex:connection.inPort.belongsToNode.nodeIndex];

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


@end
