//
//  DownloadVC.h
//  Lsh_URLSession
//
//  Created by fns on 2017/10/24.
//  Copyright © 2017年 lsh726. All rights reserved.
//

#import "BaseVC.h"
#import "MusicModel.h"

@interface DownloadVC : BaseVC
@property (nonatomic, copy) void (^MusicNameBlock)(MusicModel *model);
@end
