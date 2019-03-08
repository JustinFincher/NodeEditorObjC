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
@property (nonatomic,strong) NSMutableOrderedSet<NodeData *>* singleNodes;

- (NSUInteger)getNodeTotalCount;
- (NodeData *)getNodeWithIndex:(NSString *)index;
- (NSDictionary<NSString *,NodeData *> *)getIndexNodeDict;
- (BOOL)isSingleNode:(NodeData *)node;
@property(nonatomic, copy, nullable) void (^graphChangedBlack)(void);

- (void)updateNodeRelations;
- (void)updateNodeShaders;
- (BOOL)addNode:(NodeData *)node;
- (BOOL)removeNode:(NodeData *)node;
- (void)connectOutPort:(NodePortData *)outPort
            withInPort:(NodePortData *)inPort;
- (BOOL)canConnectOutPort:(NodePortData *)outPort
               withInPort:(NodePortData *)inPort;

@end



NS_ASSUME_NONNULL_END
