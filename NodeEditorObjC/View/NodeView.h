//
//  NodeView.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeData.h"

NS_ASSUME_NONNULL_BEGIN
@class NodeGraphView;
@interface NodeView : UIView

#pragma mark - Views
@property (nonatomic,weak) NodeGraphView *nodeGraphView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIVisualEffectView *backgroundVibrancyEffectView;
@property (nonatomic,strong) UIVisualEffectView *backgroundBlurEffectView;
#pragma mark - Gestures
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
#pragma mark - Data
@property (nonatomic,weak) NodeData *nodeData;

@end

NS_ASSUME_NONNULL_END
