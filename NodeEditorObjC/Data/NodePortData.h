//
//  NodePortData.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeConnectionData.h"
NS_ASSUME_NONNULL_BEGIN
@class NodeData;

@interface NodePortData : NSObject

@property (nonatomic,strong) NSMutableOrderedSet<NodeConnectionData *> *connections;

@property (nonatomic,strong) NSString *title;
+ (NSString *)templateTitle;

@property (nonatomic) Class requiredType;
+ (Class) templateRequiredType;

@property (nonatomic,weak) NodeData *belongsToNode;

- (void)breakConnections;

@end

NS_ASSUME_NONNULL_END
