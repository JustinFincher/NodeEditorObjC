//
//  NumberNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NumberFloatNodeData.h"
#import "NumberFloatNodePortData.h"

@interface NumberFloatNodeData()

@end
@implementation NumberFloatNodeData

+ (NSString *)templateTitle
{
    return @"Float (TextField)";
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
    return NO;
}

+ (int)templatePreviewForOutPortIndex
{
    return -1;
}

//- (NSString *)templatePreviewOutDefaultExpression
//{
//    return [NSString stringWithFormat:@"gl_FragColor = vec4(%@,%@,%@,%@); \n",
//            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
//            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
//            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
//            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName]];
//}

- (void)configureCustomValueView:(UIView *)customValueView
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, customValueView.bounds.size.width / 2, customValueView.bounds.size.height)];
    textField.placeholder = @"Float Value";
    textField.text = [self.number stringValue];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont fontWithName:@"Avenir-Black" size:10];
    [customValueView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(customValueView.bounds.size.width / 2, 0, customValueView.bounds.size.width / 2, customValueView.bounds.size.height)];
    confirmButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:10];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    [confirmButton setTitle:@"SET" forState:UIControlStateNormal];
    
    [confirmButton bk_addEventHandler:^(id sender)
    {
        [textField resignFirstResponder];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        self.number = [f numberFromString:textField.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SHADER_MODIFIED object:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [customValueView addSubview:confirmButton];

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
@end
