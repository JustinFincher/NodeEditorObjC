//
//  NodeData.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodePortData.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface NodeData : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic) NSUInteger index;
@property(nonatomic) CGPoint coordinate;
@property(nonatomic) CGSize size;
@property(nonatomic,strong) NSMutableArray<NodePortData *> *inPorts;
@property(nonatomic,strong) NSMutableArray<NodePortData *> *outPorts;

@end

NS_ASSUME_NONNULL_END
