//
//  ViewController.m
//  LJChart
//
//  Created by Beeth0ven on 3/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<LJChartViewDataSource>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setChartView:(LJChartView *)chartView
{
    _chartView = chartView;
    _chartView.dataSource = self;
}

- (NSInteger)numberOfLinesInChartView:(LJChartView *)chartView{
    
    NSLog(@"numberOfLinesInChartView: %lu",(unsigned long)self.data.count);

    return self.data.count;
}

- (NSInteger)numberOfPointsOnLineInChartView:(LJChartView *)chartView{
    
    NSLog(@"numberOfPointsOnLineInChartView: %lu",(unsigned long)((NSArray *)self.data.firstObject).count);

    return ((NSArray *)self.data.firstObject).count;
}

- (float)chartView:(LJChartView *)chartView valueForPointAtIndexPath:(NSIndexPath *)indexPath{
    
    float reslut = 0;
    NSArray *lineValues = [self.data objectAtIndex:indexPath.section];
    NSNumber *number = (NSNumber *)[lineValues objectAtIndex:indexPath.item];
    reslut = number.floatValue;
    
    return reslut;
}

- (UIColor *)chartView:(LJChartView *)chartView colorOfLine:(NSInteger)line{
    if (line == 0) {
        return [UIColor redColor];
    }else{
        return EBBlue;
    }
}


- (NSArray *)data{
    return @[
             @[@300.6,@1000,@760,@500,@1300,@200],
             @[@200,@1300,@500,@550.33,@800,@300]
             ];
}


@end
