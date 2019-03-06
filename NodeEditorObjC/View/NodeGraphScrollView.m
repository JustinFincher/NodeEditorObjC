//
//  NodeGraphScrollView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphScrollView.h"
@interface NodeGraphScrollView()<UIScrollViewDelegate>


@end

@implementation NodeGraphScrollView

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
    self.scrollEnabled = YES;
    self.userInteractionEnabled = YES;
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 0.2;
    self.delegate = self;
    self.nodeGraphView = [[NodeGraphView alloc] initWithFrame:CGRectMake(0, 0, 2000,2000)];
    self.nodeGraphView.parentScrollView = self;
    [self addSubview:self.nodeGraphView];
    self.contentSize = self.nodeGraphView.frame.size;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.nodeGraphView;
}


@end
