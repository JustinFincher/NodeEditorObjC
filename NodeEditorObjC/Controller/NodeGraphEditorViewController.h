//
//  NodeGraphEditorViewController.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeGraphView.h"
#import "NodeGraphData.h"
#import "NodeGraphScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeGraphEditorViewController : UIViewController

@property (weak, nonatomic) IBOutlet NodeGraphScrollView *nodeGraphScrollView;
@property (strong,nonatomic) NodeGraphData *nodeGraphData;

- (void) addNodebyClass:(Class)nodeClass;
- (void) addNodebyClass:(Class)nodeClass
              at:(CGPoint)point;
- (void) showNodeListControllerAt:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
