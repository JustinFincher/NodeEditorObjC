//
//  RandomVector2NodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 9/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "RandomVector2NodeData.h"
#import "Vector2NodePortData.h"
#import "NumberFloatNodePortData.h"

@implementation RandomVector2NodeData

+ (NSString *)templateTitle
{
    return @"Random (Vector2 to Vector2)";
}
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector2NodePortData *vector2Port = [[Vector2NodePortData alloc] init];
    vector2Port.title = @"Vector";
    [array addObject:vector2Port];
    return array;
}
+ (NSMutableArray<NodePortData *> *)templateInPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector2NodePortData *vector2Port = [[Vector2NodePortData alloc] init];
    vector2Port.title = @"Vector";
    [array addObject:vector2Port];
    return array;
}

+ (BOOL)templateCanHavePreview
{
    return YES;
}
+ (int)templatePreviewForOutPortIndex
{
    return 0;
}
- (NSString *)templatePreviewOutDefaultExpression
{
    return [NSString stringWithFormat:@"gl_FragColor = vec4(%@,%.8f,%.8f); \n",
            [[self.outPorts objectAtIndex:[[self class] templatePreviewForOutPortIndex]] indexToVariableName],
            [@0 floatValue],
            [@0 floatValue]];
}
- (NSString *)expressionRule
{
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         "%@ \n"
                         "vec2 %@ = -1.0 + 2.0*fract(sin(vec2( dot(%@,vec2(127.1,311.7)), dot(%@,vec2(269.5,183.3)) ))*43758.5453123);",
                         [self nodeCommentHeader],
                         (
                          [[self.inPorts objectAtIndex:0] connections].count > 0 ?
                          [[[[self.inPorts objectAtIndex:0] connections] objectAtIndex:0] expressionRule] :
                          [[self.inPorts objectAtIndex:0] templateVariableDefaultValueExpressionRule]
                          ),
                         [[self.outPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName],
                         [[self.inPorts objectAtIndex:0] indexToVariableName]];
    return string;
}
@end
