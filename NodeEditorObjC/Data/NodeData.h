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

#define NODE_WIDTH 200.0f
#define NODE_KNOT_WIDTH 30.0f
#define NODE_PORT_HEIGHT 40.0f
#define NODE_TITLE_HEIGHT 20.0f
#define NODE_PADDING_HEIGHT 8.0f

NS_ASSUME_NONNULL_BEGIN

@interface NodeData : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,copy) NSString *nodeIndex;
@property(nonatomic) CGPoint coordinate;
@property(nonatomic) CGSize size;
@property(nonatomic,strong) NSMutableArray<NodePortData *> *inPorts;
@property(nonatomic,strong) NSMutableArray<NodePortData *> *outPorts;
- (CGRect)getRecordedFrame;
- (void)postInitWork;
- (void)breakConnections;

+ (NSString *)templateTitle;
+ (CGSize)templateSize;
+ (NSMutableArray<NodePortData *> *) templateInPorts;
+ (NSMutableArray<NodePortData *> *) templateOutPorts;


- (void)prepareForDealloc;
@end

NS_ASSUME_NONNULL_END
