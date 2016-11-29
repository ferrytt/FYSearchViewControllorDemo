//
//  FYRootViewController.m
//  FYSearchViewControllorDemo
//
//  Created by 非夜 on 16/11/29.
//  Copyright © 2016年 Hefei Palm Peak Technology Co., Ltd. All rights reserved.
//

#import "FYRootViewController.h"

@interface FYRootViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UISearchController * searchViewController;

@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;

@end

@implementation FYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSStringFromClass([self class]);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createVirtualData];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.searchViewController.searchBar;
    
    // Do any additional setup after loading the view.
}

- (void)createVirtualData {
    
    self.dataList = @[].mutableCopy;
    
    for (NSInteger i = 0; i < 50; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld-FY",i]];
    }
}

- (UISearchController *)searchViewController {
    
    if (_searchViewController == nil) {
        _searchViewController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchViewController.delegate = self;
        _searchViewController.searchResultsUpdater = self;
        _searchViewController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchViewController;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchViewController.active) {
        return self.searchList.count;
    }else{
        return self.dataList.count;
    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    if (self.searchViewController.active) {
        cell.textLabel.text = [self.searchList objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
    }
    return cell;
}

// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchViewController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
