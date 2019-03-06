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

@interface NodeGraphConnectionView : UIView

@property (weak,nonatomic) NodeGraphView *graphView;

@end

NS_ASSUME_NONNULL_END
