//
//  NumberNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NumberFloatNodeData.h"
#import "NumberFloatNodePortData.h"

@interface NumberFloatNodeData()<UITextFieldDelegate>

@end
@implementation NumberFloatNodeData

+ (NSString *)templateTitle
{
    return @"Number (float)";
}

+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    NumberFloatNodePortData *numberExportPort = [[NumberFloatNodePortData alloc] init];
    numberExportPort.title = @"Value";
    [array addObject:numberExportPort];
    return array;
}

+ (CGSize)templateCustomValueViewSize
{
    return CGSizeMake(NODE_WIDTH, 30);
}

+ (BOOL)templateCanHavePreview
{
    return YES;
}

+ (int)templatePreviewForOutPortIndex
{
    return 0;
}

- (void)configureCustomValueView:(UIView *)customValueView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:customValueView.bounds];
    textField.placeholder = @"Float Value";
    textField.text = [self.number stringValue];
    textField.delegate = self;
    [customValueView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (NSString *)expressionRule
{
    NodePortData *floatOutPortData = [self.outPorts firstObject];
    NSString *string = [NSString stringWithFormat:
                        @"%@"
                        "float %@ = %.8f;",
                        [self nodeCommentHeader],
                        [floatOutPortData indexToVariableName],
                        [self.number floatValue]];
    return string;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.number = [f numberFromString:textField.text];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHADER_MODIFIED object:nil];
    return YES;
}

@end
