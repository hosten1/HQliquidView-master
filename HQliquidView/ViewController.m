//
//  ViewController.m
//  HQliquidView
//
//  Created by qianhongqiang on 15/5/29.
//  Copyright (c) 2015年 QianHongQiang. All rights reserved.
//

#import "ViewController.h"
#import "HQliquidButton.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect tabFrame =self.tabBarController.tabBar.frame;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/375;
    float percentX = (0.6/3)*scale;
    CGFloat x = ceilf(percentX * tabFrame.size.width+(5*scale));
    //    NSLog(@"tabbar >>>>>:%lf",it);
        HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(x+25,0) bagdeNumber:10];
        redPoint.bagdeLableWidth = 18;
        [self.tabBarController.tabBar addSubview:redPoint];

    // Do any additional setup after loading the view, typically from a nib.
    
//    HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(100, 200) bagdeNumber:200];
//    [self.view addSubview:redPoint];
    
    UITableView *test = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    test.delegate = self;
    test.dataSource = self;
    [self.view addSubview:test];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"testCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int num = 9;
        switch (indexPath.row) {
            case 0:
                num = 999;
                break;
            case 1:
                num = 9;
                break;
            case 2:
                num = 99;
                break;
            case 3:
                num = 99;
                break;


 
            default:
                num=99;
                break;
        }
        HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(self.view.bounds.size.width-30,20) bagdeNumber:num ];
        redPoint.bagdeLableWidth = 20;
        [cell.contentView addSubview:redPoint];
        redPoint.dragLiquidBlock = ^(HQliquidButton *liquid) {
            NSLog(@"回调乐");
        };
     
    }
    cell.textLabel.text = @"测试cell";
    return cell;
}

@end
