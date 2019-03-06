//
//  NodeView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeView.h"
#import "NodeGraphView.h"
#import "NodeData.h"

@interface NodeView()<UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIViewPropertyAnimator *scaleAnimator;
@property (nonatomic,strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic,strong) UIPushBehavior *pushBehavior;

@property (nonatomic,strong) UIView *inPortsView;
@property (nonatomic,strong) UIView *outPortsView;
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
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.backgroundBlurEffectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    self.backgroundBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundBlurEffectView.effect = blurEffect;
    self.backgroundBlurEffectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.50];
//    self.backgroundBlurEffectView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
//    self.backgroundBlurEffectView.layer.borderWidth = 0.5;
    self.backgroundBlurEffectView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
    self.backgroundBlurEffectView.layer.shadowOpacity = 1.0;
    self.backgroundBlurEffectView.layer.shadowRadius = 18;
    self.backgroundBlurEffectView.layer.masksToBounds = YES;
    self.backgroundBlurEffectView.layer.cornerRadius = 8;
    [self addSubview:self.backgroundBlurEffectView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.backgroundBlurEffectView.frame.size.width - 16, NODE_TITLE_HEIGHT)];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Oblique" size:18];
    self.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.titleLabel.textAlignment = NSTextAlignmentNatural;
    [self.backgroundBlurEffectView.contentView addSubview:self.titleLabel];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.longPressGestureRecognizer];

}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Gesture Handler
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.nodeGraphView bringSubviewToFront:self];
    __weak __typeof(self) weakSelf = self;
    [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
    [self.scaleAnimator stopAnimation:YES];
    self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                          {
                              self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                              self.backgroundBlurEffectView.layer.shadowRadius = 36;
                              self.backgroundBlurEffectView.layer.shadowOffset = CGSizeMake(0, -4);
                          }];
    [self.scaleAnimator addAnimations:^(void)
     {
         weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
         weakSelf.backgroundBlurEffectView.layer.shadowRadius = 18;
         weakSelf.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
     } delayFactor:0.5];
    [self.scaleAnimator startAnimation];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    //NSLog(@"LONG PRESS STATE = %ld",(long)recognizer.state);
    [self.nodeGraphView bringSubviewToFront:self];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                      self.backgroundBlurEffectView.layer.shadowRadius = 36;
                                      self.backgroundBlurEffectView.layer.shadowOffset = CGSizeMake(0, -4);
                                  }];
            [self.scaleAnimator startAnimation];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      self.backgroundBlurEffectView.layer.shadowRadius = 18;
                                      self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
                                  }];
            [self.scaleAnimator startAnimation];
        }
            break;
        default:
            break;
    }
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //NSLog(@"PAN STATE = %ld",recognizer.state);
    [self.nodeGraphView bringSubviewToFront:self];
    __weak __typeof(self) weakSelf = self;
    CGPoint velocity = [recognizer velocityInView:self.nodeGraphView];
//    CGPoint translation = [recognizer translationInView:self.nodeGraphView];
//    CGPoint location = [recognizer locationInView:self.nodeGraphView];
    CGPoint locationInSelf = [recognizer locationInView:self];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                      self.backgroundBlurEffectView.layer.shadowRadius = 36;
                                      self.backgroundBlurEffectView.layer.shadowOffset = CGSizeMake(0, -4);
                                  }];
            [self.scaleAnimator addCompletion:^(UIViewAnimatingPosition finalPosition)
             {
                 weakSelf.transform = CGAffineTransformMakeScale(1.1, 1.1);
                 [weakSelf.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:weakSelf];
             }];
            [self.scaleAnimator startAnimation];
            
            [self.nodeGraphView removeDynamicBehavior:self.attachmentBehavior];
//            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:[recognizer locationInView:self.nodeGraphView]];
            //NSLog(@"LOCATION %f,%f  BOUNDSSIZE %f,%f",locationInSelf.x,locationInSelf.y,self.bounds.size.width,self.bounds.size.height);
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self offsetFromCenter:UIOffsetMake(locationInSelf.x - self.bounds.size.width / 2.0f, locationInSelf.y - self.bounds.size.height / 2.0f) attachedToAnchor:[recognizer locationInView:self.nodeGraphView]];
            self.attachmentBehavior.action = ^
            {
                CGAffineTransform currentTransform = weakSelf.transform;
                weakSelf.transform = CGAffineTransformScale(currentTransform, 1.1, 1.1);
            };
            [self.nodeGraphView addDynamicBehavior:self.attachmentBehavior];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.attachmentBehavior.anchorPoint = [recognizer locationInView:self.nodeGraphView];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.scaleAnimator stopAnimation:YES];
            [self.nodeGraphView removeDynamicBehavior:self.attachmentBehavior];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      self.backgroundBlurEffectView.layer.shadowRadius = 18;
                                      self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                                  }];
            [self.scaleAnimator startAnimation];
            
            self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
            float mang = hypot(velocity.x,velocity.y);
            NSLog(@"%f",mang);
            if (mang > 100)
            {
                self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 4 / powf(mang, 0.5), velocity.y / 4 / powf(mang, 0.5));
                [self.nodeGraphView addDynamicBehavior:self.pushBehavior];
            }else
            {
                self.pushBehavior.pushDirection = CGVectorMake(0, 0);
            }
        }
            break;
        default:
            break;
    }
}
- (void)setNodeData:(NodeData *)nodeData
{
    _nodeData = nodeData;
    
    if (self.nodeData)
    {
        self.titleLabel.text = self.nodeData.title;
    }
    
   
    [self.inPortsView removeFromSuperview];
    [self.outPortsView removeFromSuperview];
    CGRect inRect = CGRectZero;
    CGRect outRect = CGRectZero;
    NSMutableArray<NodePortData *> * templateInPorts = [[self.nodeData class] templateInPorts];
    NSMutableArray<NodePortData *> * templateOutPorts = [[self.nodeData class] templateOutPorts];
    
    if (templateInPorts.count != 0 && templateOutPorts.count == 0)
    {
        inRect = CGRectMake(8,
                            NODE_TITLE_HEIGHT + 8,
                            self.backgroundBlurEffectView.contentView.frame.size.width - 16,
                            templateInPorts.count * NODE_PORT_HEIGHT);
    }
    else if (templateInPorts.count == 0 && templateOutPorts.count != 0)
    {
        outRect = CGRectMake(8,
                            NODE_TITLE_HEIGHT + 8,
                            self.backgroundBlurEffectView.contentView.frame.size.width - 16,
                            templateOutPorts.count * NODE_PORT_HEIGHT);
    }
    else if (templateInPorts.count != 0 && templateOutPorts.count != 0)
    {
        inRect = CGRectMake(8,
                            NODE_TITLE_HEIGHT + 8,
                            self.backgroundBlurEffectView.contentView.frame.size.width / 2 - 12,
                            templateInPorts.count * NODE_PORT_HEIGHT);
        outRect = CGRectMake(self.backgroundBlurEffectView.contentView.frame.size.width / 2 + 4,
                             NODE_TITLE_HEIGHT + 8,
                             self.backgroundBlurEffectView.contentView.frame.size.width / 2 - 12,
                             templateOutPorts.count * NODE_PORT_HEIGHT);
    }
    if (inRect.size.height != 0 && inRect.size.width != 0)
    {
        self.inPortsView = [[UIView alloc] initWithFrame:inRect];
        self.inPortsView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1f];
        self.inPortsView.layer.cornerRadius = 4;
        self.inPortsView.layer.masksToBounds = YES;
        self.inPortsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.backgroundBlurEffectView.contentView addSubview:self.inPortsView];
        
        for (int i = 0; i < templateInPorts.count; i ++ )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * NODE_PORT_HEIGHT, self.inPortsView.frame.size.width, NODE_PORT_HEIGHT)];
            label.text = [[templateInPorts objectAtIndex:i] title];
            label.font = [UIFont fontWithName:@"Avenir-Black" size:10];
            label.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
            label.textAlignment = NSTextAlignmentLeft;
            [self.inPortsView addSubview:label];
        }
    }
    if (outRect.size.height != 0 && outRect.size.width != 0)
    {
        self.outPortsView = [[UIView alloc] initWithFrame:outRect];
        self.outPortsView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
        self.outPortsView.layer.cornerRadius = 4;
        self.outPortsView.layer.masksToBounds = YES;
        self.outPortsView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.backgroundBlurEffectView.contentView addSubview:self.outPortsView];
        
        for (int i = 0; i < templateOutPorts.count; i ++ )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, i * NODE_PORT_HEIGHT, self.outPortsView.frame.size.width, NODE_PORT_HEIGHT)];
            label.text = [[templateOutPorts objectAtIndex:i] title];
            label.font = [UIFont fontWithName:@"Avenir-Black" size:10];
            label.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
            label.textAlignment = NSTextAlignmentRight;
            [self.outPortsView addSubview:label];
        }
    }
}

@end
