//
//  NodeGraphView.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeGraphData.h"
#import "NodeData.h"
#import "NodePortData.h"
#import "NodeView.h"

NS_ASSUME_NONNULL_BEGIN
@class NodeGraphView;
@class NodeGraphConnectionView;
@protocol NodeGraphViewDataSource <NSObject>

- (NodeView *)nodeGraphView:(NodeGraphView *)graphView nodeForIndex:(NSString *)index;
- (NSUInteger)nodeCountInGraphView:(NodeGraphView *)graphView;
- (NodeData *)nodeGraphView:(NodeGraphView *)graphView nodeDataForIndex:(NSString *)index;
- (NSDictionary<NSString *,NodeData *> *)getIndexNodeDict;
- (BOOL)canConnectOutPort:(NodePortData *)outPort
               withInPort:(NodePortData *)inPort;
- (BOOL)canConnectOutPortPoint:(CGPoint)outPortPoint
               withInPortPoint:(CGPoint)inPortPoint;
- (void)connectOutPort:(NodePortData *)outPort
            withInPort:(NodePortData *)inPort;
- (NodePortView *)portViewFrom:(CGPoint)point;

@optional

@end

@protocol NodeGraphViewVisualDelegate <NSObject>

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSString *)index;

@end

@protocol NodeGraphViewConnectionDataSource <NSObject>

- (void)port:(NodePortData *)portA
 connectedTo:(NodePortData *)portB;

@end

@protocol NodeGraphViewConnectionVisualDelegate <NSObject>

-  (void)currentPointAt:(CGPoint)endPosition
               dragging:(BOOL)isDragging
                   from:(NodePortView *_Nullable)portView;

@end

@class NodeGraphScrollView;
@interface NodeGraphView : UIView

- (void)reloadData;
@property (nonatomic, weak) NodeGraphScrollView *parentScrollView;
@property (nonatomic, weak) id <NodeGraphViewDataSource> dataSource;
@property (nonatomic, weak) id <NodeGraphViewVisualDelegate> visualDelegate;
@property (nonatomic, weak) id <NodeGraphViewConnectionDataSource> connectionDataSource;
@property (nonatomic, weak) id <NodeGraphViewConnectionVisualDelegate> connectionVisualDelegate;
@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic,strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic,strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic,strong) UIView *nodeContainerView;
@property (nonatomic,strong) NodeGraphConnectionView *nodeConnectionLineView;
- (void)addDynamicBehavior:(UIDynamicBehavior *)behavior;
- (void)removeDynamicBehavior:(UIDynamicBehavior *)behavior;
- (void)handleKnotPanGesture:(UIPanGestureRecognizer *)gesture;

@end

NS_ASSUME_NONNULL_END
