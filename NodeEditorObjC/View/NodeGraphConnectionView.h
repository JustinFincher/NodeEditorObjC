//
//  NodeGraphConnectionView.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeGraphData.h"
#import "NodeGraphView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NodeGraphViewConnectionVisualDelegate <NSObject>

- (void)currentConnectionUpdated:(NodePortData *)startPort
                                :(CGPoint)endPosition;
@end

@interface NodeGraphConnectionView : UIView

@property (weak,nonatomic) NodeGraphView *graphView;
@property (nonatomic, weak) id <NodeGraphViewConnectionVisualDelegate> connectionVisualDelegate;

@end

NS_ASSUME_NONNULL_END
