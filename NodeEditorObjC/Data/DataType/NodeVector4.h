//
//  Vector4.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeVector4 : NSObject

@property (nonatomic,strong) NSNumber *x;
@property (nonatomic,strong) NSNumber *y;
@property (nonatomic,strong) NSNumber *z;
@property (nonatomic,strong) NSNumber *w;

- (instancetype)initWithX:(float)x
                        Y:(float)y
                        Z:(float)z
                        W:(float)w;

@end

NS_ASSUME_NONNULL_END
