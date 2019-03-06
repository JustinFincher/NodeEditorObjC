//
//  NodePortView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortView.h"
#import "NodeData.h"
@interface NodePortView()

@end

@implementation NodePortView

- (instancetype)initWithFrame:(CGRect)frame
                     portData:(NodePortData *)data
                    isOutPort:(BOOL)isOut
{
    self = [super initWithFrame:frame];
    
    _nodePortData = data;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(isOut ? 0 : NODE_KNOT_WIDTH,
                                                                0,
                                                                self.frame.size.width - NODE_KNOT_WIDTH,
                                                                self.frame.size.height)];
    self.titleLabel.text = data.title;
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10];
    self.titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    self.titleLabel.textAlignment = isOut ? NSTextAlignmentRight : NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.knotButton = [[UIButton alloc] initWithFrame:CGRectMake(isOut ? self.frame.size.width - NODE_KNOT_WIDTH : 0, 0, NODE_KNOT_WIDTH, NODE_PORT_HEIGHT)];
    [self addSubview:self.knotButton];
    
    self.knotIndicator = [[UIView alloc] initWithFrame:CGRectMake(NODE_KNOT_WIDTH / 2 - NODE_PORT_HEIGHT / 8,
                                                                  NODE_PORT_HEIGHT / 2 - NODE_PORT_HEIGHT / 8,
                                                                  NODE_PORT_HEIGHT / 4,
                                                                  NODE_PORT_HEIGHT / 4)];
    self.knotIndicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.knotIndicator.layer.cornerRadius = NODE_PORT_HEIGHT / 8;
    self.knotIndicator.layer.masksToBounds = YES;
    [self.knotButton addSubview:self.knotIndicator];
    return self;
}

@end
