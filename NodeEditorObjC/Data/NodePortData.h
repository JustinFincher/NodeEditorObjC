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

@property (nonatomic,strong) NSMutableSet<NodeConnectionData *> *connections;
@property (nonatomic,strong) NSString *portName;
@property (nonatomic) Class requiredType;
@property (nonatomic,weak) NodeData *belongsToNode;

@end

NS_ASSUME_NONNULL_END
