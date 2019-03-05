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
@protocol NodeGraphViewDataSource <NSObject>

- (NodeView *)nodeGraphView:(NodeGraphView *)graphView nodeForIndex:(NSUInteger)index;
- (NSUInteger)nodeCountInGraphView:(NodeGraphView *)graphView;

@optional

@end

@protocol NodeGraphViewVisualDelegate <NSObject>

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSUInteger)index;

@end

@interface NodeGraphView : UIView

- (void)reloadData;
@property (nonatomic, weak) id <NodeGraphViewDataSource> dataSource;
@property (nonatomic, weak) id <NodeGraphViewVisualDelegate> visualDelegate;

@end

NS_ASSUME_NONNULL_END
