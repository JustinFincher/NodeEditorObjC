//
//  Vector2.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Vector2 : NSObject

@property (nonatomic,strong) NSNumber *x;
@property (nonatomic,strong) NSNumber *y;

- (instancetype)initWithX:(float)x
                        Y:(float)y;

@end

NS_ASSUME_NONNULL_END
