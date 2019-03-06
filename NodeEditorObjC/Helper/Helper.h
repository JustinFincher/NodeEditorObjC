//
//  Helper.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

+ (NSArray *)ClassGetSubclasses:(Class)parentClass;
+ (NSArray *)ClassGetNodeSubclasses;
+ (NSArray *)ClassGetNodePortSubclasses;

@end

NS_ASSUME_NONNULL_END
