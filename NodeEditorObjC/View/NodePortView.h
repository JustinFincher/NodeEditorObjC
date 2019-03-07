//
//  NodePortView.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodePortData.h"
NS_ASSUME_NONNULL_BEGIN

@class NodeView;
@interface NodePortView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *knotButton;
@property (nonatomic,strong) UIView *knotIndicator;
@property (nonatomic,weak) NodePortData *nodePortData;
@property (nonatomic,weak) NodeView *nodeView;
@property (nonatomic) BOOL isOutPort;
@property (nonatomic,strong) UIPanGestureRecognizer *knotPanGesgtureRecognizer;

- (instancetype)initWithFrame:(CGRect)frame
                     portData:(NodePortData *)data
                    isOutPort:(BOOL)isOut
                     nodeView:(NodeView *)nodeView;

+ (NodePortView *)getNodePortFromKnotView:(UIView *)knotView;

@end

NS_ASSUME_NONNULL_END
