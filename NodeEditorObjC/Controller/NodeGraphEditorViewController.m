//
//  NodeGraphEditorViewController.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphEditorViewController.h"
#import "NodeListTableViewController.h"
#import "NodeInstanceDebugTableViewController.h"
#import "Hackpad.h"
#import "NodePortView.h"
#import "NodePortKnotView.h"

@interface NodeGraphEditorViewController ()<NodeGraphViewDataSource,NodeGraphViewVisualDelegate>

@end

@implementation NodeGraphEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    // Do any additional setup after loading the view.
    
    self.title = @"Shader Node Editor";
    
    self.nodeGraphData = [[NodeGraphData alloc] init];
    self.nodeGraphData.graphChangedBlack = ^()
    {
        [weakSelf.nodeGraphScrollView.nodeGraphView reloadData];
    };
    self.nodeGraphScrollView.nodeGraphView.dataSource = self;
    self.nodeGraphScrollView.nodeGraphView.visualDelegate = self;
    
    self.navigationItem.leftBarButtonItems = @[
                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(debugButttonPressed:)],
                                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButttonPressed:)]
                                               ];
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButttonPressed:)]
                                                ];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_SHOW_NODE_LIST object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
        [self showNodeListControllerAt:[[[notification userInfo] valueForKey:@"point"] CGPointValue]];
    }];
    
//    [[Hackpad sharedManager] testNodeOn:self];
    // Reload
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}

#pragma mark - UI Event
- (void)refreshButttonPressed:(UIBarButtonItem *)item
{
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}
- (void)debugButttonPressed:(UIBarButtonItem *)item
{
    NodeInstanceDebugTableViewController *tableViewController = [[NodeInstanceDebugTableViewController alloc] init];
    tableViewController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = tableViewController.popoverPresentationController;
    if (popover)
    {
        popover.barButtonItem = item;
        popover.delegate = tableViewController;
    }
    tableViewController.graphController = self;
    [self presentViewController:tableViewController animated:YES completion:nil];
}
- (void)addButttonPressed:(UIBarButtonItem *)item
{
    NodeListTableViewController *tableViewController = [[NodeListTableViewController alloc] init];
    tableViewController.modalPresentationStyle = UIModalPresentationPopover;
    tableViewController.graphEditorViewController = self;
    UIPopoverPresentationController *popover = tableViewController.popoverPresentationController;
    if (popover)
    {
        popover.barButtonItem = item;
        popover.delegate = tableViewController;
    }
    [self presentViewController:tableViewController animated:YES completion:nil];
}

- (void) showNodeListControllerAt:(CGPoint)point
{
    NodeListTableViewController *tableViewController = [[NodeListTableViewController alloc] init];
    tableViewController.modalPresentationStyle = UIModalPresentationPopover;
    tableViewController.graphEditorViewController = self;
    UIPopoverPresentationController *popover = tableViewController.popoverPresentationController;
    if (popover)
    {
        popover.sourceRect = CGRectMake(point.x, point.y, 1,1);
        popover.sourceView = self.nodeGraphScrollView.nodeGraphView.nodeContainerView;
        popover.delegate = tableViewController;
    }
    [self presentViewController:tableViewController animated:YES completion:nil];
}

#pragma mark - Data Event
- (void) addNodebyClass:(Class)nodeClass
{
    [self.nodeGraphData addNode:[[nodeClass alloc] init]];
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}
- (void) addNodebyClass:(Class)nodeClass
              at:(CGPoint)point
{
    NodeData *node = [[nodeClass alloc] init];
    node.coordinate = CGPointMake(point.x - node.size.width / 2, point.y - node.size.height / 2);
    [self.nodeGraphData addNode:node];
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}

#pragma mark - NodeGraphViewDataSource

- (NodeView *)nodeGraphView:(NodeGraphView *)graphView nodeForIndex:(NSString *)index
{
    CGPoint coordinate = [[self.nodeGraphData getNodeWithIndex:index] coordinate];
    CGSize size = [[self.nodeGraphData getNodeWithIndex:index] size];
    NodeView *node = [[NodeView alloc] initWithFrame:CGRectMake(coordinate.x, coordinate.y, size.width, size.height)];
    node.nodeGraphView = self.nodeGraphScrollView.nodeGraphView;
    node.nodeData = [self.nodeGraphData getNodeWithIndex:index];
    
    return node;
}
- (NSUInteger)nodeCountInGraphView:(NodeGraphView *)graphView
{
    return [self.nodeGraphData getNodeTotalCount];
}
- (NodeData *)nodeGraphView:(NodeGraphView *)graphView nodeDataForIndex:(NSString *)index
{
    return [self.nodeGraphData getNodeWithIndex:index];
}
- (NSDictionary<NSString *,NodeData *> *)getIndexNodeDict
{
    return [[self nodeGraphData] getIndexNodeDict];
}
- (BOOL)canConnectOutPort:(NodePortData *)outPort withInPort:(NodePortData *)inPort
{
    return [self.nodeGraphData canConnectOutPort:outPort withInPort:inPort];
}
- (BOOL)canConnectOutPortPoint:(CGPoint)outPortPoint withInPortPoint:(CGPoint)inPortPoint
{
    NodePortView *outPortView = [self portViewFrom:outPortPoint];
    NodePortView *inPortView = [self portViewFrom:inPortPoint];
    return inPortView && outPortView && [self canConnectOutPort:outPortView.nodePortData withInPort:inPortView.nodePortData];
}
- (NodePortView *)portViewFrom:(CGPoint)point
{
    UIView *portViewHitTest = [self.nodeGraphScrollView.nodeGraphView.nodeContainerView hitTest:point withEvent:nil];
    if ([portViewHitTest isKindOfClass:[NodePortKnotView class]])
    {
        return [NodePortView getNodePortFromKnotView:(NodePortKnotView *)portViewHitTest];
    }
    return nil;
}
- (void)connectOutPort:(NodePortData *)outPort withInPort:(NodePortData *)inPort
{
    return [self.nodeGraphData connectOutPort:outPort withInPort:inPort];
}
-(void)deleteNode:(NodeData *)node
{
    [self.nodeGraphData removeNode:node];
}
- (void)addNode:(NodeData *)node
{
    [self.nodeGraphData addNode:node];
}

#pragma mark - NodeGraphViewVisualDelegate

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSString *)index
{
    CGPoint coordinate = [[self.nodeGraphData getNodeWithIndex:index] coordinate];
    CGSize size = [[self.nodeGraphData getNodeWithIndex:index] size];
    return CGRectMake(coordinate.x, coordinate.y, size.width, size.height);
}

@end
