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
@property (strong,nonatomic)HQliquidButton *cuteView;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / self.tabBarController.viewControllers.count;
    self.cuteView = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(width / 2,0)];    self.cuteView.bagdeLableWidth = 18;
    self.cuteView.maxDistance = 100;
    self.cuteView.maxTouchDistance = 25;
    self.cuteView.bagdeNumber = 10;
    [self.tabBarController.tabBar addSubview:self.cuteView];

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
    
        HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(self.view.bounds.size.width-30,20)];
        redPoint.maxTouchDistance = 30;
        redPoint.bagdeLableWidth = 18;
        redPoint.maxDistance = 100;
        redPoint.bagdeNumber = num;
        [cell.contentView addSubview:redPoint];
        redPoint.dragLiquidBlock = ^(HQliquidButton *liquid) {
            if (liquid) {
               
                NSLog(@"hosten HQliquidButton block 这里处理需要的信息");
            }
        };
     
    }
    cell.textLabel.text = @"测试cell";
    return cell;
}

@end
