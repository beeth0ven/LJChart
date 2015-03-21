//
//  LJChartView.h
//  LJChart
//
//  Created by Beeth0ven on 3/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#define EBBlue          [UIColor colorWithRed:95.0 / 255.0 green:200.0 / 255.0 blue:220.0 / 255.0 alpha:1.0f]
#define EBBackGround    [UIColor colorWithRed:137.0 / 255.0 green:142.0 / 255.0 blue:145.0 / 255.0 alpha:1.0f]


#import <UIKit/UIKit.h>



@protocol LJChartViewDataSource;


@interface LJChartView : UIView

@property (nonatomic, assign) id <LJChartViewDataSource> dataSource;

@end


@protocol LJChartViewDataSource <NSObject>

@required

- (NSInteger)numberOfLinesInChartView:(LJChartView *)chartView;

- (NSInteger)numberOfPointsOnLineInChartView:(LJChartView *)chartView;

- (UIColor *)chartView:(LJChartView *)chartView colorOfLine:(NSInteger)line;

- (float)chartView:(LJChartView *)chartView valueForPointAtIndexPath:(NSIndexPath *)indexPath;

@optional


@end