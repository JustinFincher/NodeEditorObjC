//
//  NodeView.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeView.h"
#import "NodeGraphView.h"

@interface NodeView()<UIGestureRecognizerDelegate>


@property (nonatomic,strong) UIViewPropertyAnimator *scaleAnimator;
@property (nonatomic,strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic,strong) UIPushBehavior *pushBehavior;

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
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.backgroundBlurEffectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    self.backgroundBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundBlurEffectView.effect = blurEffect;
    self.backgroundBlurEffectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.50];
    self.backgroundBlurEffectView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
    self.backgroundBlurEffectView.layer.borderWidth = 0.5;
    self.backgroundBlurEffectView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f].CGColor;
    self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
    self.backgroundBlurEffectView.layer.shadowOpacity = 1.0;
    self.backgroundBlurEffectView.layer.shadowRadius = 6;
    self.backgroundBlurEffectView.layer.masksToBounds = YES;
    self.backgroundBlurEffectView.layer.cornerRadius = 8;
    [self addSubview:self.backgroundBlurEffectView];
    
//    self.backgroundVibrancyEffectView = [[UIVisualEffectView alloc] initWithFrame:self.backgroundBlurEffectView.bounds];
//    self.backgroundVibrancyEffectView.effect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    self.backgroundVibrancyEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.backgroundBlurEffectView.contentView addSubview:self.backgroundVibrancyEffectView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 200, 100)];
    self.titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    __weak __typeof(self) weakSelf = self;
    [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
    [self.scaleAnimator stopAnimation:YES];
    self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                          {
                              self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                              self.backgroundBlurEffectView.layer.shadowRadius = 12;
                              self.backgroundBlurEffectView.layer.shadowOffset = CGSizeMake(0, -4);
                          }];
    [self.scaleAnimator addAnimations:^(void)
     {
         weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
         weakSelf.backgroundBlurEffectView.layer.shadowRadius = 6;
         weakSelf.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
     } delayFactor:0.5];
    [self.scaleAnimator startAnimation];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    //NSLog(@"LONG PRESS STATE = %ld",(long)recognizer.state);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:0.5 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                      self.backgroundBlurEffectView.layer.shadowRadius = 12;
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
                                      self.backgroundBlurEffectView.layer.shadowRadius = 6;
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
                                      self.backgroundBlurEffectView.layer.shadowRadius = 12;
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
                                      self.backgroundBlurEffectView.layer.shadowRadius = 6;
                                      self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                                  }];
            [self.scaleAnimator startAnimation];
            
            self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
            float mang = hypot(velocity.x,velocity.y);
            NSLog(@"%f",mang);
            if (mang > 100)
            {
                self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10 / powf(mang, 0.5), velocity.y / 10 / powf(mang, 0.5));
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
}

@end
