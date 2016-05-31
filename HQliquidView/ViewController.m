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
                num = 9333;
                break;


 
            default:
                break;
        }
        HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(200, 20) bagdeNumber:num ];
        redPoint.bagdeLableWidth = 16;
        [cell.contentView addSubview:redPoint];
    }
    return cell;
}

@end
