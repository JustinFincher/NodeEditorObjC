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
#import "NodePortView.h"
#import "NodeGraphConnectionView.h"
@interface NodeView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIViewPropertyAnimator *scaleAnimator;
@property (nonatomic,strong) UIViewPropertyAnimator *borderAnimator;
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
//    self.layer.cornerRadius = 8;
//    self.layer.masksToBounds = YES;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.backgroundBlurEffectView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    self.backgroundBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundBlurEffectView.effect = blurEffect;
    self.backgroundBlurEffectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.50];
    self.backgroundBlurEffectView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundBlurEffectView.layer.shadowOffset = CGSizeZero;
    self.backgroundBlurEffectView.layer.shadowOpacity = 1.0;
    self.backgroundBlurEffectView.layer.shadowRadius = 18;
    self.backgroundBlurEffectView.layer.masksToBounds = YES;
    self.backgroundBlurEffectView.layer.cornerRadius = 8;
    
//    self.backgroundBlurEffectView.layer.borderColor = [[UIColor orangeColor] colorWithAlphaComponent:0.6f].CGColor;
//    self.backgroundBlurEffectView.layer.borderWidth = 3;
    
    [self addSubview:self.backgroundBlurEffectView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(NODE_PADDING_HEIGHT, NODE_PADDING_HEIGHT, self.backgroundBlurEffectView.frame.size.width - 16, NODE_TITLE_HEIGHT)];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Oblique" size:16];
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
    
    self.ports = [NSMutableOrderedSet orderedSet];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_SHADER_VIEW_NEED_RELOAD object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notif)
     {
         [self updateSelfShader];
     }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Gesture Handler
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.nodeGraphView.nodeContainerView bringSubviewToFront:self];
    self.makeFocusBlock(self.nodeData);
    __weak __typeof(self) weakSelf = self;
    [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
    [self.scaleAnimator stopAnimation:YES];
    self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:1 animations:^(void)
                          {
                              self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                              [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                          }];
    [self.scaleAnimator addAnimations:^(void)
     {
         weakSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
     } delayFactor:0.5];
    [self.scaleAnimator startAnimation];
    
    [self resignFirstResponder];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    [self.nodeGraphView.nodeContainerView bringSubviewToFront:self];
    self.makeFocusBlock(self.nodeData);
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:1 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                                  }];
            [self.scaleAnimator startAnimation];
            
            [self becomeFirstResponder];
            [[UIMenuController sharedMenuController] setTargetRect:self.bounds inView:self];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:1 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
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
    [self.nodeGraphView.nodeContainerView bringSubviewToFront:self];
    self.makeFocusBlock(self.nodeData);
    __weak __typeof(self) weakSelf = self;
    CGPoint velocity = [recognizer velocityInView:self.nodeGraphView.nodeContainerView];
    CGPoint locationInSelf = [recognizer locationInView:self];
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self.nodeGraphView removeDynamicBehavior:self.pushBehavior];
            [self.scaleAnimator stopAnimation:YES];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:1 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.1, 1.1);
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                                  }];
            [self.scaleAnimator addCompletion:^(UIViewAnimatingPosition finalPosition)
             {
                 weakSelf.transform = CGAffineTransformMakeScale(1.1, 1.1);
                 [weakSelf.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:weakSelf];
             }];
            [self.scaleAnimator startAnimation];
            
            [self.nodeGraphView removeDynamicBehavior:self.attachmentBehavior];
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self offsetFromCenter:UIOffsetMake(locationInSelf.x - self.bounds.size.width / 2.0f, locationInSelf.y - self.bounds.size.height / 2.0f) attachedToAnchor:[recognizer locationInView:self.nodeGraphView.nodeContainerView]];
            self.attachmentBehavior.action = ^
            {
                [weakSelf updateSelfInAnimator];
                CGAffineTransform currentTransform = weakSelf.transform;
                weakSelf.transform = CGAffineTransformScale(currentTransform, 1.1, 1.1);
            };
            [self.nodeGraphView addDynamicBehavior:self.attachmentBehavior];
            
            
            [self resignFirstResponder];
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.attachmentBehavior.anchorPoint = [recognizer locationInView:self.nodeGraphView.nodeContainerView];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.scaleAnimator stopAnimation:YES];
            [self.nodeGraphView removeDynamicBehavior:self.attachmentBehavior];
            self.scaleAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:0.5 dampingRatio:1 animations:^(void)
                                  {
                                      self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
                                  }];
            [self.scaleAnimator startAnimation];
            
            self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
            self.pushBehavior.action = ^
            {
                [weakSelf updateSelfInAnimator];
            };
            float mang = hypot(velocity.x,velocity.y);
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
    [self.inPortsView removeFromSuperview];
    [self.outPortsView removeFromSuperview];
    
    _nodeData = nodeData;
    
    if (!self.nodeData)
    {
        return;
    }
    
    self.nodeData.isFocusedChangedBlock = ^(BOOL isFocused)
    {
        [self updateSelfInAnimator];
    };
    
    self.titleLabel.text = self.nodeData.title;
    CGRect inRect = CGRectZero;
    CGRect outRect = CGRectZero;
    NSMutableArray<NodePortData *> * inPorts = [self.nodeData inPorts];
    NSMutableArray<NodePortData *> * outPorts = [self.nodeData outPorts];
    
    if (inPorts.count != 0 && outPorts.count == 0)
    {
        inRect = CGRectMake(NODE_PADDING_HEIGHT,
                            NODE_TITLE_HEIGHT + NODE_PADDING_HEIGHT + [nodeData customValueViewSize].height,
                            self.backgroundBlurEffectView.contentView.frame.size.width - NODE_PADDING_HEIGHT * 2,
                            inPorts.count * NODE_PORT_HEIGHT);
    }
    else if (inPorts.count == 0 && outPorts.count != 0)
    {
        outRect = CGRectMake(NODE_PADDING_HEIGHT,
                             NODE_TITLE_HEIGHT + NODE_PADDING_HEIGHT + [nodeData customValueViewSize].height,
                             self.backgroundBlurEffectView.contentView.frame.size.width - NODE_PADDING_HEIGHT * 2,
                             outPorts.count * NODE_PORT_HEIGHT);
    }
    else if (inPorts.count != 0 && outPorts.count != 0)
    {
        inRect = CGRectMake(8,
                            NODE_TITLE_HEIGHT + NODE_PADDING_HEIGHT + [nodeData customValueViewSize].height,
                            self.backgroundBlurEffectView.contentView.frame.size.width / 2 - NODE_PADDING_HEIGHT * 3 / 2,
                            inPorts.count * NODE_PORT_HEIGHT);
        outRect = CGRectMake(self.backgroundBlurEffectView.contentView.frame.size.width / 2 + NODE_PADDING_HEIGHT / 2,
                             NODE_TITLE_HEIGHT + NODE_PADDING_HEIGHT + [nodeData customValueViewSize].height,
                             self.backgroundBlurEffectView.contentView.frame.size.width / 2 - NODE_PADDING_HEIGHT * 3 / 2,
                             outPorts.count * NODE_PORT_HEIGHT);
    }
    
    if (inRect.size.height != 0 && inRect.size.width != 0)
    {
        self.inPortsView = [[UIView alloc] initWithFrame:inRect];
        self.inPortsView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1f];
        self.inPortsView.layer.cornerRadius = 4;
        self.inPortsView.layer.masksToBounds = YES;
        self.inPortsView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self.backgroundBlurEffectView.contentView addSubview:self.inPortsView];
        
        for (int i = 0; i < inPorts.count; i ++ )
        {
            NodePortView *nodePortView = [[NodePortView alloc] initWithFrame:CGRectMake(0,
                                                                                        i * NODE_PORT_HEIGHT,
                                                                                        self.inPortsView.frame.size.width,
                                                                                        NODE_PORT_HEIGHT)
                                                                    portData:[inPorts objectAtIndex:i] isOutPort:NO nodeView:self];
            nodePortView.nodeView = self;
            [self.panGestureRecognizer requireGestureRecognizerToFail:nodePortView.knotPanGesgtureRecognizer];
            [self.longPressGestureRecognizer requireGestureRecognizerToFail:nodePortView.knotPanGesgtureRecognizer];
            [self.inPortsView addSubview:nodePortView];
            [self.ports addObject:nodePortView];
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
        
        for (int i = 0; i < outPorts.count; i ++ )
        {
            NodePortView *nodePortView = [[NodePortView alloc] initWithFrame:CGRectMake(0, i * NODE_PORT_HEIGHT, self.outPortsView.frame.size.width, NODE_PORT_HEIGHT) portData:[outPorts objectAtIndex:i] isOutPort:YES nodeView:self];
            [self.panGestureRecognizer requireGestureRecognizerToFail:nodePortView.knotPanGesgtureRecognizer];
            [self.longPressGestureRecognizer requireGestureRecognizerToFail:nodePortView.knotPanGesgtureRecognizer];
            [self.outPortsView addSubview:nodePortView];
            [self.ports addObject:nodePortView];
        }
    }
    
    [self updateSelfShader];
    [self.customValueView removeFromSuperview];
    self.customValueView = [[UIView alloc] initWithFrame:CGRectMake(NODE_PADDING_HEIGHT,
                                                                    NODE_PADDING_HEIGHT +
                                                                    NODE_TITLE_HEIGHT,
                                                                    NODE_WIDTH - NODE_PADDING_HEIGHT * 2,
                                                                    nodeData.customValueViewSize.height
                                                                    )];
    self.customValueView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.customValueView];
    [self.nodeData configureCustomValueView:self.customValueView];
}

- (void)updateSelfShader
{
    [self.shaderPreviewView removeFromSuperview];
    if ([[self.nodeData class] templateCanHavePreview] && self.nodeData.previewForOutPortIndex >= 0)
    {
        self.shaderPreviewView = [[SKView alloc] initWithFrame:CGRectMake(NODE_PADDING_HEIGHT,
                                                                          NODE_PADDING_HEIGHT +
                                                                          NODE_TITLE_HEIGHT + // for title
                                                                          fmaxf([[self.nodeData inPorts] count] * NODE_PORT_HEIGHT, [[self.nodeData outPorts] count] * NODE_PORT_HEIGHT) + // for ports
                                                                          [self.nodeData customValueViewSize].height +
                                                                          NODE_PADDING_HEIGHT, // for custom view
                                                                          NODE_WIDTH - NODE_PADDING_HEIGHT * 2,
                                                                          NODE_WIDTH - NODE_PADDING_HEIGHT * 2
                                                                          )];
        self.shaderPreviewView.layer.cornerRadius = 8;
        self.shaderPreviewView.layer.masksToBounds = YES;
        SKScene *scene = [SKScene sceneWithSize:self.shaderPreviewView.bounds.size];
        scene.anchorPoint = CGPointMake(0.5, 0.5);
        SKSpriteNode *spriteNode = [[SKSpriteNode alloc] initWithColor:[UIColor grayColor] size:scene.size];
        NSString *shaderStr = [self.nodeData previewTotalOutExpression];
        NSLog(@"%@",shaderStr);
        SKShader *shader = [SKShader shaderWithSource:shaderStr];
        spriteNode.shader = shader;
        [scene addChild:spriteNode];
        [self.shaderPreviewView presentScene:scene];
        [self addSubview:self.shaderPreviewView];
    }
}
- (void)updateSelfInAnimator
{
    self.nodeData.coordinate = self.frame.origin;
    self.nodeData.size = self.frame.size;
    self.backgroundBlurEffectView.layer.borderColor = self.nodeData.isFocused ? [[UIColor orangeColor] colorWithAlphaComponent:0.6f].CGColor : [UIColor clearColor].CGColor;
    self.backgroundBlurEffectView.layer.borderWidth = self.nodeData.isFocused ? 4.0f : 0.0f;
    [self.nodeGraphView.dynamicAnimator updateItemUsingCurrentState:self];
    [self.nodeGraphView.nodeConnectionLineView setNeedsDisplay];
}

#pragma mark - Menu
- (void) menuItemClicked:(id) sender
{
    
}

- (void) delete:(id)sender
{
    [self.nodeGraphView.dataSource deleteNode:self.nodeData];
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender
{
    if (selector == @selector(menuItemClicked:) ||
        selector == @selector(delete:))
    {
        return YES;
    }
    return NO;
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}
@end
