//
//  NodeListTableViewController.m
//  NodeEditorObjC
//
//  Created by Justin Fincher on 6/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

#import "NodeListTableViewController.h"
#import "NodeData.h"
#import "Helper.h"

@interface NodeListTableViewController ()

@property (nonatomic,strong) NSMutableOrderedSet<Class> *nodeSubclasses;

@end

@implementation NodeListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.nodeSubclasses = [NSMutableOrderedSet orderedSetWithArray:[Helper ClassGetNodeSubclasses]];
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nodeSubclasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Class class = [self.nodeSubclasses objectAtIndex:indexPath.row];
    cell.textLabel.text = [class templateTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.graphEditorViewController)
    {
        return;
    }
    if ([self.presentationController isKindOfClass:[UIPopoverPresentationController class]] && [(UIPopoverPresentationController *)(self.presentationController) barButtonItem] == nil)
    {
        [self.graphEditorViewController addNodebyClass:[self.nodeSubclasses objectAtIndex:indexPath.row] at:[(UIPopoverPresentationController *)(self.presentationController) sourceRect].origin];
    }else
    {
        [self.graphEditorViewController addNodebyClass:[self.nodeSubclasses objectAtIndex:indexPath.row]];
    }
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


@end
