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
#define NODE_CONNECTION_CURVE_CONTROL_OFFSET 90.0f
#define NOTIFICATION_NODE_CONNECTION_START @"NOTIFICATION_NODE_CONNECTION_START"
#define NOTIFICATION_NODE_CONNECTION_END @"NOTIFICATION_NODE_CONNECTION_END"
#define NOTIFICATION_SHOW_NODE_LIST @"NOTIFICATION_SHOW_NODE_LIST"
#define NOTIFICATION_SHADER_MODIFIED @"NOTIFICATION_SHADER_MODIFIED"
#define NOTIFICATION_SHADER_VIEW_NEED_RELOAD @"NOTIFICATION_SHADER_VIEW_NEED_RELOAD"

NS_ASSUME_NONNULL_BEGIN

@interface NodeData : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,copy) NSString *nodeIndex;
@property(nonatomic) CGPoint coordinate;
@property(nonatomic) CGSize size;
@property(nonatomic) CGSize customValueViewSize;
@property(nonatomic) BOOL isFocused;
@property(nonatomic, copy, nullable) void (^isFocusedChangedBlock)(BOOL isFocused);
@property(nonatomic,strong) NSMutableArray<NodePortData *> *inPorts;
@property(nonatomic,strong) NSMutableArray<NodePortData *> *outPorts;
@property(nonatomic) int previewForOutPortIndex;

- (CGRect)getRecordedFrame;
- (void)postInitWork;
- (void)breakConnections;

- (NSString *)expressionRule;
- (NSString *)templatePreviewOutDefaultExpression;
- (NSString *)previewTotalOutExpression;
@property (nonatomic,strong) NSString * shaderProgram;


+ (BOOL)templateCanHavePreview;
+ (int)templatePreviewForOutPortIndex;
+ (NSString *)templateTitle;
+ (CGSize)templateSize;
+ (CGSize)templateCustomValueViewSize;
+ (NSMutableArray<NodePortData *> *) templateInPorts;
+ (NSMutableArray<NodePortData *> *) templateOutPorts;

- (void)prepareForDealloc;
- (void)configureCustomValueView:(UIView *)customValueView;

- (NSString *)nodeCommentHeader;

@end

NS_ASSUME_NONNULL_END
