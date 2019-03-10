//
//  NodePortView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortView.h"
#import "NodeGraphView.h"
#import "NodeData.h"
#import "NodeView.h"

#define NODE_PORT_INDICATOR_INACTIVE_COLOR [[UIColor blackColor] colorWithAlphaComponent:0.1];
#define NODE_PORT_INDICATOR_ACTIVE_COLOR [[UIColor redColor] colorWithAlphaComponent:0.6];

@interface NodePortView()

@end

@implementation NodePortView

- (instancetype)initWithFrame:(CGRect)frame
                     portData:(NodePortData *)data
                    isOutPort:(BOOL)isOut
                     nodeView:(nonnull NodeView *)nodeView
{
    self = [super initWithFrame:frame];
    
    _nodePortData = data;
    _nodeView = nodeView;
    _isOutPort = isOut;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(isOut ? 0 : NODE_KNOT_WIDTH,
                                                                0,
                                                                self.frame.size.width - NODE_KNOT_WIDTH,
                                                                self.frame.size.height)];
    self.titleLabel.text = data.title;
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10];
    self.titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.titleLabel.textAlignment = isOut ? NSTextAlignmentRight : NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.knotView = [[NodePortKnotView alloc] initWithFrame:CGRectMake(isOut ? self.frame.size.width - NODE_KNOT_WIDTH : 0, 0, NODE_KNOT_WIDTH, NODE_PORT_HEIGHT)];
    [self addSubview:self.knotView];
    self.knotPanGesgtureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.nodeView.nodeGraphView action:@selector(handleKnotPanGesture:)];
    [self.knotView addGestureRecognizer:self.knotPanGesgtureRecognizer];
    
    self.knotIndicator = [[UIView alloc] initWithFrame:CGRectMake(NODE_KNOT_WIDTH / 2 - NODE_PORT_HEIGHT / 8,
                                                                  NODE_PORT_HEIGHT / 2 - NODE_PORT_HEIGHT / 8,
                                                                  NODE_PORT_HEIGHT / 4,
                                                                  NODE_PORT_HEIGHT / 4)];
    self.knotIndicator.backgroundColor = NODE_PORT_INDICATOR_INACTIVE_COLOR;
    self.knotIndicator.layer.cornerRadius = NODE_PORT_HEIGHT / 8;
    self.knotIndicator.layer.masksToBounds = YES;
    [self.knotView addSubview:self.knotIndicator];
    return self;
}

+ (NodePortView *)getNodePortFromKnotView:(NodePortKnotView *)knotView
{
    UIView *view = knotView;
    while (![view isKindOfClass:[NodePortView class]] && [view superview] != nil)
    {
        view = [view superview];
    }
    return [view isKindOfClass:[NodePortView class]] ? (NodePortView *)view : nil;
}
@end
