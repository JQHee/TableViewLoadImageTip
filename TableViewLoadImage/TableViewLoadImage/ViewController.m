//
//  ViewController.m
//  TableViewLoadImage
//
//  Created by MAC on 2017/2/13.
//  Copyright © 2017年 MAC. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cellArray = [NSMutableArray array];
    [self setupUI];
}

- (void) setupUI {
    self.tableView.rowHeight = 100;
}

#pragma mark - UITableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (! cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if((self.tableView.isDragging || self.tableView.isDecelerating) && ![self.cellArray containsObject:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"12"];
        // 滚动时取消任务的下载
        //[cell.imageView sd_cancelCurrentImageLoad];
        return cell;
    }
    
    //__weak typeof(self) weakSelf = self;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic35.nipic.com/20131121/2531170_145358633000_2.jpg"] placeholderImage:[UIImage imageNamed:@"12"]];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic35.nipic.com/20131121/2531170_145358633000_2.jpg"] placeholderImage:[UIImage imageNamed:@"12"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (![self.cellArray containsObject:indexPath]) {
//            [self.cellArray addObject:indexPath];
//        }
//        if (image && cacheType == SDImageCacheTypeNone) {
//            CATransition *transition = [CATransition animation];
//            transition.type = kCATransitionFade;
//            transition.duration = 0.3;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            // weakself.layer
//            [cell.imageView.layer addAnimation:transition forKey:nil];
//        }
//        
//    }];
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 慢滑结束触发
    if (! decelerate) {
        [self reLoad];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 慢滑结束触发
    [self reLoad];
    
}

#pragma mark - Private Methods
- (void) reLoad {
    // 刷新当前可见的cells
    NSArray *arry = [self.tableView indexPathsForVisibleRows];
    NSMutableArray *arrToReload = [NSMutableArray array];
    for (NSIndexPath *indexPath in arry) {
        if (! [self.cellArray containsObject:indexPath]) {
            [arrToReload addObject:indexPath];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:arrToReload withRowAnimation:(UITableViewRowAnimationFade)];

}

@end
