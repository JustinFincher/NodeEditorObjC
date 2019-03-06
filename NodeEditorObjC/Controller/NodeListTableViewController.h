//
//  NodeListTableViewController.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeGraphEditorViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NodeListTableViewController : UITableViewController<UIPopoverPresentationControllerDelegate>

@property (nonatomic,weak) NodeGraphEditorViewController *graphEditorViewController;

@end

NS_ASSUME_NONNULL_END
