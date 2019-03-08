//
//  NodeConnectionData.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NodePortData;
NS_ASSUME_NONNULL_BEGIN

@interface NodeConnectionData : NSObject
@property (nonatomic,strong) NodePortData *inPort;
@property (nonatomic,weak) NodePortData *outport;

- (NSString *)expressionRule;
@end

NS_ASSUME_NONNULL_END
