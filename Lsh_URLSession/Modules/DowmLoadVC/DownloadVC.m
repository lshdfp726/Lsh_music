//
//  DownloadVC.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/24.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "DownloadVC.h"
#import "DownloadView.h"

#define URL @"http://127.0.0.1/yishengsuoai.mp3"

@interface DownloadVC ()
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UILabel *downLoadDataLabel;
@property (nonatomic, strong) UITextField *urlTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self config];
    [self setUpView];
}


- (void)setUpView {
    
    self.urlTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2 , 64 + 10, 150.0, 40.0)];
    self.urlTextField.backgroundColor = [UIColor lightGrayColor];
    self.urlTextField.font = [UIFont systemFontOfSize:14.0];
    self.urlTextField.placeholder = @"输入或者复制资源地址";
    [self.view addSubview:self.urlTextField];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150.0)/2 , self.urlTextField.frame.origin.y + 40.0 + 10.0, 150.0, 60.0)];
    self.nameTextField.backgroundColor = [UIColor lightGrayColor];
    self.nameTextField.font = [UIFont systemFontOfSize:14.0];
    self.nameTextField.placeholder = @"给你的歌曲取个名字吧";
    [self.view addSubview:self.nameTextField];
    
    
    self.downLoadDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0,  self.nameTextField.frame.origin.y + 60.0 + 10.0 , 70.0 , 15.0)];
    self.downLoadDataLabel.font = [UIFont systemFontOfSize:14.0];
    self.downLoadDataLabel.text = @"";
    [self.view addSubview:self.downLoadDataLabel];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.downLoadDataLabel.frame.origin.y + 15.0 + 5.0, 0.0, 1.0)];
    self.progressLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.progressLabel];
    
}


- (void)config {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下载任务";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(downloadMusic)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToVC)];
    self.navigationItem.leftBarButtonItem = back;
  
}


- (void)backToVC {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)downloadMusic {
    NSURLSessionManager *manager = [NSURLSessionManager sessionSharce];
    if (self.urlTextField.text.length == 0) {
        self.urlTextField.text = @"请输入下载地址";
        return;
    }
    
    __block NSString *nameText = _nameTextField.text;
    
    [manager downloadWithUrl:_urlTextField.text params:@{} progress:^(NSProgress * _Nullable progress) {
        CGFloat bate = (CGFloat)progress.completedUnitCount/(CGFloat)progress.totalUnitCount;
        self.progressLabel.frame = CGRectMake(self.progressLabel.frame.origin.x, self.progressLabel.frame.origin.y, self.view.frame.size.width * bate, 1.0);
        self.downLoadDataLabel.text = [NSString stringWithFormat:@"%.2f%%",bate];
    } success:^(NSURLSessionDownloadTask * _Nonnull task, NSURL * _Nullable location) {
        self.downLoadDataLabel.text = @"下载完成!";
        //保存的沙盒路径名称
        NSString *saveName = [NSString stringWithFormat:@"music%d",arc4random() %100];
        NSArray *temp = [[NSUserDefaults standardUserDefaults] valueForKey:MUSIC];
        //排除重名！
        for (NSDictionary *d in temp) {
            if ([d.allValues containsObject:saveName]) {
                saveName = [saveName stringByAppendingString:@"-"];
            }
        }
        
        //存到沙盒
        [[Lsh_fileManager fileManager] copyItemUrl:location.path destFileName:saveName];
        MusicModel *model = [[MusicModel alloc] init];
        model.name = nameText == nil?saveName:self.nameTextField.text;
        model.url = [[Lsh_fileManager fileManager] getFileWithName:saveName];
        
        NSDictionary *dic = @{model.name:saveName};
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dic];
        
        [[Lsh_fileManager fileManager] saveUrlToUserdefalut:array];
        self.MusicNameBlock(model);
    } failure:^(NSURLSessionDownloadTask * _Nonnull task, NSError * _Nullable error) {
        NSLog(@"%@",error);
        if (error) {
            self.downLoadDataLabel.text = error.localizedDescription;
        }
        
    }];
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
