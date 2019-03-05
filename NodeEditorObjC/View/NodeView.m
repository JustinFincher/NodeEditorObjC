//
//  NodeView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeView.h"

@interface NodeView()

@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property CGPoint panCoordinate;

@end

@implementation NodeView

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
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.backgroundBlurEffectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    self.backgroundBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundBlurEffectView.effect = blurEffect;
    
    self.backgroundVibrancyEffectView = [[UIVisualEffectView alloc] initWithFrame:self.backgroundBlurEffectView.bounds];
    self.backgroundVibrancyEffectView.effect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    self.backgroundVibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.backgroundBlurEffectView.contentView addSubview:self.backgroundVibrancyEffectView];
    
    self.backgroundBlurEffectView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
    self.backgroundBlurEffectView.layer.shadowOpacity = 1.0;
    self.backgroundBlurEffectView.layer.shadowRadius = 6;
    self.backgroundBlurEffectView.layer.masksToBounds = YES;
    self.backgroundBlurEffectView.layer.cornerRadius = 8;
    [self addSubview:self.backgroundBlurEffectView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200, 100)];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.backgroundVibrancyEffectView.contentView addSubview:self.titleLabel];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)setNodeData:(NodeData *)nodeData
{
    _nodeData = nodeData;
    
    if (self.nodeData)
    {
        self.titleLabel.text = self.nodeData.title;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.panCoordinate = [gesture locationInView:gesture.view];
    }
    CGPoint newCoord = [gesture locationInView:gesture.view];
    float dX = newCoord.x-self.panCoordinate.x;
    float dY = newCoord.y-self.panCoordinate.y;
    gesture.view.frame = CGRectMake(gesture.view.frame.origin.x+dX, gesture.view.frame.origin.y+dY, gesture.view.frame.size.width, gesture.view.frame.size.height);
}
@end
