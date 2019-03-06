//
//  Helper.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "Helper.h"
#import "NodeData.h"
#import "NodePortData.h"


@implementation Helper

+ (NSArray *)ClassGetSubclasses:(Class)parentClass;
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = (Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}


+ (NSArray *)ClassGetNodeSubclasses
{
    return [Helper ClassGetSubclasses:[NodeData class]];
}
+ (NSArray *)ClassGetNodePortSubclasses
{
    return [Helper ClassGetSubclasses:[NodePortData class]];
}

@end
