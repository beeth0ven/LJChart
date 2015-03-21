//
//  ViewController.h
//  LJChart
//
//  Created by Beeth0ven on 3/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJChartView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet LJChartView *chartView;
@property (nonatomic, strong) UITableView *tbv;

@end

