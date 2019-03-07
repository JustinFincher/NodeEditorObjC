//
//  NodePortKnotView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 7/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodePortKnotView.h"

@implementation NodePortKnotView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(CGRectMake(4, 4, self.bounds.size.width - 8, self.bounds.size.height - 8) , point) ? self : nil;
}

@end
