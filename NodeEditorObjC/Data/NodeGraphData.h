//
//  NodeGraphData.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeData.h"
#import "NodePortData.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeGraphData : NSObject


/**
 Nodes with their out ports not connected
 */
@property (nonatomic,strong) NSMutableSet<NodeData *>* singleNodes;

- (BOOL)canConnectFrom:(NodePortData *)nodePortOut To:(NodePortData *)nodePortIn;
- (BOOL)connectFrom:(NodePortData *)nodePortOut To:(NodePortData *)nodePortIn;

- (NSUInteger)getNodeTotalCount;
- (NodeData *)getNodeWithIndex:(NSUInteger)index;
- (NSDictionary<NSNumber*,NodeData *> *)getIndexNodeDict;

- (BOOL)addNode:(NodeData *)node;

@end



NS_ASSUME_NONNULL_END
