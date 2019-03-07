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

@optional

@end

@protocol NodeGraphViewVisualDelegate <NSObject>

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSString *)index;

@end

@protocol NodeGraphViewConnectionDataSource <NSObject>

- (void)port:(NodePortData *)portA
 connectedTo:(NodePortData *)portB;

@end

@class NodeGraphScrollView;
@interface NodeGraphView : UIView

- (void)reloadData;
@property (nonatomic, weak) NodeGraphScrollView *parentScrollView;
@property (nonatomic, weak) id <NodeGraphViewDataSource> dataSource;
@property (nonatomic, weak) id <NodeGraphViewVisualDelegate> visualDelegate;
@property (nonatomic, weak) id <NodeGraphViewConnectionDataSource> connectionDataSource;
@property (nonatomic,strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic,strong) UIDynamicItemBehavior *dynamicItemBehavior;
@property (nonatomic,strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic,strong) UIView *nodeContainerView;
@property (nonatomic,strong) NodeGraphConnectionView *nodeConnectionLineView;
- (void)addDynamicBehavior:(UIDynamicBehavior *)behavior;
- (void)removeDynamicBehavior:(UIDynamicBehavior *)behavior;

@end

NS_ASSUME_NONNULL_END
