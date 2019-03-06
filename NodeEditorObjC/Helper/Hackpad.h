//
//  Hackpad.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeGraphEditorViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Hackpad : NSObject

+ (id)sharedManager;
- (void)testNodeOn:(NodeGraphEditorViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
