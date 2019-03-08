//
//  NodeView.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeData.h"
@import SpriteKit;

typedef void (^VoidBlock)(void);
NS_ASSUME_NONNULL_BEGIN
@class NodeGraphView;
@class NodePortView;
@interface NodeView : UIView

#pragma mark - Views
@property (nonatomic,weak) NodeGraphView *nodeGraphView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIVisualEffectView *backgroundBlurEffectView;
@property (nonatomic,strong) NSMutableOrderedSet<NodePortView *> *ports;
@property (nonatomic,strong) SKView *shaderPreviewView;
@property (nonatomic,strong) UIView *customValueView;

#pragma mark - Gestures
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, copy, nullable) void (^makeFocusBlock)(NodeData *nodeData);
#pragma mark - Data
@property (nonatomic,weak) NodeData *nodeData;


- (void)updateSelfInAnimator;
- (void)updateSelfShader;


@end

NS_ASSUME_NONNULL_END
