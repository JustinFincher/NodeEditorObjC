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

@interface NodePortView : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *knotButton;
@property (nonatomic,strong) UIView *knotIndicator;
@property (nonatomic,weak) NodePortData *nodePortData;
@property (nonatomic) BOOL isOutPort;

- (instancetype)initWithFrame:(CGRect)frame
                     portData:(NodePortData *)data
                    isOutPort:(BOOL)isOut;

@end

NS_ASSUME_NONNULL_END
