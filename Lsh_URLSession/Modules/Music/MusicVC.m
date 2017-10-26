//
//  MusicVC.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "MusicVC.h"
#import "DownloadVC.h"
#import "MusicModel.h"
#import "PlayerView.h"
#import "MPlayer.h"
#define CELLID NSStringFromClass([self class])



@interface MusicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray <MusicModel *> *dataSource;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation MusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
    [self setUpView];
    [self requestData];
}


- (void)setUpView {
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    self.myTableView = tableView;

}


- (void)config {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"音乐列表";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(jumpDownload)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.dataSource = [NSMutableArray array];
}


- (void)requestData {
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:MUSIC];
    for (NSDictionary *d in array) {
        MusicModel *model = [[MusicModel alloc] init];
        model.name = [d.allKeys firstObject];
        model.url  = [[Lsh_fileManager fileManager] getFileWithName:[d.allValues firstObject]];
        [self.dataSource addObject:model];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

//跳转到下载页面
- (void)jumpDownload {
    DownloadVC *vc = [[DownloadVC alloc] init];
    vc.MusicNameBlock = ^(MusicModel *model) {
        [self.dataSource addObject:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text   = [NSString stringWithFormat:@"歌曲名称:%@",[self.dataSource[indexPath.row] name]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = self.dataSource[indexPath.row];
    NSString *path = model.url;
    if (path != nil) {
        [[MPlayer playerManager] playerWithUrl:path];
    }
    
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
