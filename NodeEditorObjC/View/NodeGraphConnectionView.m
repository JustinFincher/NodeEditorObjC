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
@property (nonatomic,weak) NodePortView *dragFromNodePortView;

@end

@implementation NodeGraphConnectionView
#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame nodeGraphView:(NodeGraphView *)nodeGraphView
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _nodeGraphView = nodeGraphView;
        [self postInitWork];
    }
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
        UIColor *color;
        
        if (self.isDragging)
        {
            BOOL canConnect = NO;
            CGPoint draggingStartPos = CGPointMake(
                                               [self.dragFromNodePortView.nodeView convertRect:self.dragFromNodePortView.knotIndicator.bounds fromView:self.dragFromNodePortView.knotIndicator].origin.x + self.dragFromNodePortView.knotIndicator.bounds.size.width / 2 + self.dragFromNodePortView.nodeView.nodeData.coordinate.x,
                                               [self.dragFromNodePortView.nodeView convertRect:self.dragFromNodePortView.knotIndicator.bounds fromView:self.dragFromNodePortView.knotIndicator].origin.y + self.dragFromNodePortView.knotIndicator.bounds.size.height / 2 + self.dragFromNodePortView.nodeView.nodeData.coordinate.y);
            CGPoint draggingEndPos = self.currentPosition;

            UIBezierPath *path = [UIBezierPath bezierPath];
            if ([self.dragFromNodePortView.nodePortData isInPortRelativeToConnection])
            {
                canConnect = [self.nodeGraphView.dataSource canConnectOutPortPoint:draggingStartPos withInPortPoint:draggingEndPos];
                [path moveToPoint:draggingStartPos];
                [path addCurveToPoint:self.currentPosition controlPoint1:CGPointMake(draggingStartPos.x + NODE_CONNECTION_CURVE_CONTROL_OFFSET, draggingStartPos.y) controlPoint2:CGPointMake(self.currentPosition.x - NODE_CONNECTION_CURVE_CONTROL_OFFSET, self.currentPosition.y)];
            }else if ([self.dragFromNodePortView.nodePortData isOutPortRelativeToConnection])
            {
                canConnect = [self.nodeGraphView.dataSource canConnectOutPortPoint:draggingEndPos withInPortPoint:draggingStartPos];
                [path moveToPoint:self.currentPosition];
                [path addCurveToPoint:draggingStartPos controlPoint1:CGPointMake(self.currentPosition.x + NODE_CONNECTION_CURVE_CONTROL_OFFSET, self.currentPosition.y) controlPoint2:CGPointMake(draggingStartPos.x - NODE_CONNECTION_CURVE_CONTROL_OFFSET, draggingStartPos.y)];
            }
            color = canConnect ? [[UIColor greenColor] colorWithAlphaComponent:0.6f] : [[UIColor redColor] colorWithAlphaComponent:0.6f];
            [color set];
            path.lineWidth = 8.0;
            path.lineCapStyle = kCGLineCapRound; //线条拐角
            path.lineJoinStyle = kCGLineJoinRound; //终点处理
            [path stroke];
        }
        
        color = [[UIColor yellowColor] colorWithAlphaComponent:0.6f];
        [color set];
        
        NSUInteger count = [self.nodeGraphView.dataSource nodeCountInGraphView:self.nodeGraphView];
        for (int i = 0; i < count; i ++)
        {
            NodeData *outNodeData = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeDataForIndex:[[NSNumber numberWithInteger:i]stringValue]];
            NodeView *outNodeView = outNodeData.nodeView;
            
            for (NodePortData *port in outNodeData.inPorts)
            {
                for (NodeConnectionData *connection in port.connections)
                {
                    NodeData *inNodeData = [self.nodeGraphView.dataSource nodeGraphView:self.nodeGraphView nodeDataForIndex:connection.inPort.belongsToNode.nodeIndex];
                    NodeView *inNodeView = inNodeData.nodeView;

                    NodePortView *inNodePortView = [[inNodeView.ports filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodePortData.portIndex == %@",connection.inPort.portIndex]] firstObject];
                    NodePortView *outNodePortView = [[outNodeView.ports filteredOrderedSetUsingPredicate:[NSPredicate predicateWithFormat:@"nodePortData.portIndex == %@",connection.outport.portIndex]] firstObject];
                    
                    
                    CGPoint inNodePoint = CGPointMake(
                                                      [inNodeView convertRect:inNodePortView.knotIndicator.bounds fromView:inNodePortView.knotIndicator].origin.x + inNodePortView.knotIndicator.bounds.size.width / 2 + inNodeData.coordinate.x,
                                                      [inNodeView convertRect:inNodePortView.knotIndicator.bounds fromView:inNodePortView.knotIndicator].origin.y + inNodePortView.knotIndicator.bounds.size.height / 2 + inNodeData.coordinate.y);
                    
                    CGPoint outNodePoint = CGPointMake(
                                                       [outNodeView convertRect:outNodePortView.knotIndicator.bounds fromView:outNodePortView.knotIndicator].origin.x + outNodePortView.knotIndicator.bounds.size.width / 2 + outNodeData.coordinate.x,
                                                       [outNodeView convertRect:outNodePortView.knotIndicator.bounds fromView:outNodePortView.knotIndicator].origin.y + outNodePortView.knotIndicator.bounds.size.height / 2 + outNodeData.coordinate.y);
                    
                    UIBezierPath *path = [UIBezierPath bezierPath];
                    [path moveToPoint:outNodePoint];
                    [path addCurveToPoint:inNodePoint controlPoint1:CGPointMake(outNodePoint.x - NODE_CONNECTION_CURVE_CONTROL_OFFSET, outNodePoint.y) controlPoint2:CGPointMake(inNodePoint.x + NODE_CONNECTION_CURVE_CONTROL_OFFSET, inNodePoint.y)];
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
-  (void)currentPointAt:(CGPoint)endPosition dragging:(BOOL)isDragging from:(NodePortView *)portView
{
    _currentPosition = endPosition;
    _isDragging = isDragging;
    _dragFromNodePortView = portView;
    [self setNeedsDisplay];
}

@end
