//
//  TexCoordinateNodeData.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 8/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "TexCoordinateNodeData.h"
#import "NumberFloatNodePortData.h"
#import "Vector2NodePortData.h"

@implementation TexCoordinateNodeData

+ (NSString *)templateTitle
{
    return @"UV (v_tex_coord)";
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
+ (NSMutableArray<NodePortData *> *)templateOutPorts
{
    NSMutableArray<NodePortData *> * array = [NSMutableArray array];
    Vector2NodePortData *uvExportPort = [[Vector2NodePortData alloc] init];
    uvExportPort.title = @"Value";
    [array addObject:uvExportPort];
    return array;
}

- (NSString *)expressionRule
{
    NodePortData *timePortData = [self.outPorts objectAtIndex:0];
    NSString *string =  [NSString stringWithFormat:
                         @"%@"
                         @"vec2 %@ = v_tex_coord;",
                         [self nodeCommentHeader],
                         [timePortData indexToVariableName]];
    return string;
}
@end
