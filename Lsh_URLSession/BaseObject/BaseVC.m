//
//  BaseVC.m
//  Lsh_URLSession
//
//  Created by fns on 2017/10/20.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "BaseVC.h"

#define  FILENAME @"yishengsuoai"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    tap.cancelsTouchesInView =  NO;
    [self.view addGestureRecognizer:tap];
}


- (void)endEdit {
    [self.view endEditing:YES];
}

- (void)config {
    
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
