//
//  NodeInstanceDebugTableViewController.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 7/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeInstanceDebugTableViewController.h"

@interface NodeInstanceDebugTableViewController ()

@property (nonatomic,strong) NSArray<NodeData *> * nodes;

@end

@implementation NodeInstanceDebugTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)setGraphController:(NodeGraphEditorViewController *)graphController
{
    _graphController = graphController;
    self.nodes = [[[graphController nodeGraphData] getIndexNodeDict] allValues];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nodes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                    reuseIdentifier:@"cell"];
    NodeData *data = [self.nodes objectAtIndex:indexPath.row];
    cell.textLabel.text =  [NSString stringWithFormat:@"%@ %@",data.nodeIndex,data.title];
    
    NSString *detail = @"";
    detail = [detail stringByAppendingString:[NSString stringWithFormat:@"SINGLE NODE: %@", [[self.graphController nodeGraphData] isSingleNode:data] ? @"YES" : @"NO" ]];
    
    detail = [detail stringByAppendingString:@"\n"];
    detail = [detail stringByAppendingString:[NSString stringWithFormat:@"FOCUS: %@", [data isFocused] ? @"YES" : @"NO" ]];
    
    for (NodePortData *port in data.inPorts)
    {
        detail = [detail stringByAppendingString:@"\n"];
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@"PORT: %@ %@",port.portIndex,port.title]];
        for (NodeConnectionData *connection in port.connections)
        {
            detail = [detail stringByAppendingString:@"\n   "];
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"CONNECTION: %@ %@ %@",connection.inPort.portIndex,connection.inPort.title,connection.inPort.belongsToNode.title]];
        }
    }
    for (NodePortData *port in data.outPorts)
    {
        detail = [detail stringByAppendingString:@"\n"];
        detail = [detail stringByAppendingString:[NSString stringWithFormat:@"PORT: %@ %@",port.portIndex,port.title]];
        for (NodeConnectionData *connection in port.connections)
        {
            detail = [detail stringByAppendingString:@"\n   "];
            detail = [detail stringByAppendingString:[NSString stringWithFormat:@"CONNECTION: %@ %@ %@",connection.outport.portIndex,connection.outport.title,connection.outport.belongsToNode.title]];
        }
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = detail;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

@end
