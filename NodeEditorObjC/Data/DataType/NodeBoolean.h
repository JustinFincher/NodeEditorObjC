//
//  NodeBoolean.h
//  NodeEditorObjC
//
//  Created by Justin Fincher on 10/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeBoolean : NSObject

@property (nonatomic,strong) NSNumber *value;
@property (nonatomic,strong) NSNumber *y;

- (instancetype)initWith:(BOOL)va;


@end

NS_ASSUME_NONNULL_END
