//
//  NodeGraphEditorViewController.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 5/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeGraphEditorViewController.h"
#import "NodeListTableViewController.h"
#import "Hackpad.h"

@interface NodeGraphEditorViewController ()<NodeGraphViewDataSource,NodeGraphViewVisualDelegate>

@end

@implementation NodeGraphEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Shader Node Editor";
    
    self.nodeGraphData = [[NodeGraphData alloc] init];
    self.nodeGraphScrollView.nodeGraphView.dataSource = self;
    self.nodeGraphScrollView.nodeGraphView.visualDelegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightAddButttonPressed:)];
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_SHOW_NODE_LIST object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
        [self showNodeListControllerAt:[[[notification userInfo] valueForKey:@"point"] CGPointValue]];
    }];
    
//    [[Hackpad sharedManager] testNodeOn:self];
    // Reload
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}

#pragma mark - UI Event
- (void)rightAddButttonPressed:(UIBarButtonItem *)item
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
        popover.sourceRect = CGRectMake(point.x - 5, point.y - 5, 10,10);
        popover.sourceView = self.nodeGraphScrollView.nodeGraphView.nodeContainerView;
        popover.delegate = tableViewController;
    }
    [self presentViewController:tableViewController animated:YES completion:nil];
}

#pragma mark - Data Event
- (void) addNode:(Class)nodeClass
{
    [self.nodeGraphData addNode:[[nodeClass alloc] init]];
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}
- (void) addNode:(Class)nodeClass
              at:(CGPoint)point
{
    NodeData *node = [[nodeClass alloc] init];
    node.coordinate = point;
    [self.nodeGraphData addNode:node];
    [self.nodeGraphScrollView.nodeGraphView reloadData];
}

#pragma mark - NodeGraphViewDataSource

- (NodeView *)nodeGraphView:(NodeGraphView *)graphView nodeForIndex:(NSString *)index
{
    CGPoint coordinate = [[self.nodeGraphData getNodeWithIndex:index] coordinate];
    CGSize size = [[self.nodeGraphData getNodeWithIndex:index] size];
    NodeView *node = [[NodeView alloc] initWithFrame:CGRectMake(coordinate.x, coordinate.y, size.width, size.height)];
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
#pragma mark - NodeGraphViewVisualDelegate

- (CGRect)nodeGraphView:(NodeGraphView *)graphView frameForIndex:(NSString *)index
{
    CGPoint coordinate = [[self.nodeGraphData getNodeWithIndex:index] coordinate];
    CGSize size = [[self.nodeGraphData getNodeWithIndex:index] size];
    return CGRectMake(coordinate.x, coordinate.y, size.width, size.height);
}

@end
