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
#import "TestTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *datasArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.cellArray = [NSMutableArray array];
    [self initWtihData];
    [self setupUI];
}

- (void) initWtihData {
    self.datasArray = [NSMutableArray arrayWithObjects:
                       @"http://pic35.nipic.com/20131121/2531170_145358633000_2.jpg",
                       @"http://img3.imgtn.bdimg.com/it/u=2320677199,2423076609&fm=214&gp=0.jpg",
                       @"http://pic64.nipic.com/file/20150410/18791845_083643162070_2.jpg",
                       @"http://pic44.nipic.com/20140717/2531170_194615292000_2.jpg",
                       @"http://img02.tooopen.com/images/20140504/sy_60294738471.jpg",
                       @"http://pic41.nipic.com/20140518/18521768_133448822000_2.jpg",
                       @"http://img3.redocn.com/tupian/20150319/huaduoxiantiaoLxingbiankuang_4023214.jpg",
                       @"http://m2.quanjing.com/2m/alamyrf005/b1fw89.jpg",
                       @"http://img13.poco.cn/mypoco/myphoto/20120828/15/55689209201208281549023849547194135_001.jpg",
                       @"http://pic44.nipic.com/20140721/11624852_001107119409_2.jpg",
                       @"http://img3.redocn.com/tupian/20150430/mantenghuawenmodianshiliangbeijing_3924704.jpg",
                       @"http://pic73.nipic.com/file/20150724/18576408_175304314596_2.jpg",
                       @"http://img05.tooopen.com/images/20150531/tooopen_sy_127457023651.jpg",
                       @"http://m2.quanjing.com/2m/tongro_rf002/tds003tg2260.jpg",
                       @"http://pic47.nipic.com/20140904/18981839_095218870000_2.jpg",
                       nil];
}

- (void) setupUI {
    self.tableView.rowHeight = 100;
    [self setupNavBar];
    [self.tableView reloadData];
}

- (void) setupNavBar {

}

#pragma mark - UITableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    if((self.tableView.isDragging || self.tableView.isDecelerating) && ![self.cellArray containsObject:indexPath]) {
            [cell.testImageV sd_setImageWithURL:[NSURL URLWithString:self.datasArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"icon_abc"]];
            // 滚动时取消任务的下载
            [cell.testImageV sd_cancelCurrentImageLoad];
        return cell;
    }
    
    [cell.testImageV sd_setImageWithURL:[NSURL URLWithString:self.datasArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"icon_abc"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (![self.cellArray containsObject:indexPath]) {
            [self.cellArray addObject:indexPath];
        }
        if (image && cacheType == SDImageCacheTypeNone) {
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionFade;
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            // weakself.layer
            [cell.testImageV.layer addAnimation:transition forKey:nil];
        }
        
    }];
    return cell;
}

#pragma mark - UITableViewDelegate Methods 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self.tableView reloadData];
    }];
    [[SDImageCache sharedImageCache] clearMemory];

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
    // UITableViewRowAnimationFade
    [self.tableView reloadRowsAtIndexPaths:arrToReload withRowAnimation:(UITableViewRowAnimationNone)];

}

@end
