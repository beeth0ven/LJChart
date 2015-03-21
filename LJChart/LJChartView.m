//
//  LJChartView.m
//  LJChart
//
//  Created by Beeth0ven on 3/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "LJChartView.h"
#import "NSString+Extension.h"

@interface LJChartView ()

@property (nonatomic) NSInteger maxCoordinateVerticalValue;
@property (nonatomic) CGFloat controlPiontOffset;

@end


@implementation LJChartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    [self transformToMacCoordinate];
    
    [self drawSeparater];
    
    [self drawLines];

}

- (void)transformToMacCoordinate{
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextScaleCTM(context,
                      1.0f,
                      -1.0f);
    
    CGContextTranslateCTM(context,
                          0.0f,
                          - self.bounds.size.height);
    
}

#define SeparaterCount 5


- (void)drawSeparater{
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat separaterHight = self.bounds.size.height / SeparaterCount;
    
    NSInteger count = 1;
    for (count = 1;
         count < 1 + SeparaterCount;
         count++) {
        
        // draw separater
        
        CGFloat y = count * separaterHight;
        
        CGContextMoveToPoint(context,
                             self.bounds.origin.x,
                             y);
        
        CGContextAddLineToPoint(context,
                                self.bounds.size.width,
                                y);
        
        [[UIColor grayColor] set];
        
        CGContextSetLineWidth(context,
                              0.2);
        
        CGContextStrokePath(context);
        
        
        // draw coordinate vertical label
        
        if (count < SeparaterCount) {
            
            NSString *string = [NSString stringWithFormat:@"%i",
                                self.maxCoordinateVerticalValue * count / 5];
            
            CGPoint point = CGPointMake(self.bounds.origin.x + 10,
                                        y - 5);
            
            NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
            
            [string drawInMacCoordinateAtPoint:point
                                withAttributes:attributes];
        }
        
       
        
    }

}

- (void)drawLines{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger lineCount = [self.dataSource numberOfLinesInChartView:self];
    NSInteger line = 0;
    for (line = 0;
         line < lineCount;
         line++) {
        
        CGMutablePathRef path = [self pathOnLine:line];
        UIColor *color = [self.dataSource chartView:self colorOfLine:line];
        
        [[color colorWithAlphaComponent:0.2] setFill];
        
        [[color colorWithAlphaComponent:0.5] setStroke];
        
        CGContextSetLineWidth(context,
                              3);
        
        CGContextAddPath(context,
                         path);
        
        CGContextDrawPath(context,
                          kCGPathFillStroke);
        
        CGPathRelease(path);
        
    }

}


- (CGMutablePathRef)pathOnLine:(NSInteger)line{
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path,
                      NULL,
                      self.bounds.size.width,
                      self.bounds.origin.y);
    
    CGPathAddLineToPoint(path,
                         NULL,
                         self.bounds.origin.x,
                         self.bounds.origin.y);
    
    NSInteger pointCount = [self.dataSource numberOfPointsOnLineInChartView:self];
    
    if (pointCount < 3) {
        NSLog(@"Failed to create path,number of Points on line is less than three.");
        return path;
    }
    
    NSInteger point = 0;
    for (point = 0;
         point < pointCount;
         point++) {
        
        CGPoint
        prePoint,
        currentPoint,
        nextPoint,
        firstControlPoint,
        secondControlPoint;
       
        currentPoint = [self pointForPointIndex:point onLine:line];

        if (point == 0) {
            // first point
            CGPathAddLineToPoint(path,
                                 NULL,
                                 currentPoint.x,
                                 currentPoint.y);
            continue;
            
        }else {
            // nomal point
            prePoint = [self pointForPointIndex:point - 1 onLine:line];
            
            firstControlPoint = [self firstControlPointBetweenCurrentPoint:currentPoint
                                                                  prePoint:prePoint];
            //very smart , I'm so clever.
            
            nextPoint = (point == pointCount -1) ? prePoint :[self pointForPointIndex:point + 1 onLine:line];
            
            secondControlPoint = [self secondControlPointBetweenCurrentPoint:currentPoint
                                                                   nextPoint:nextPoint];
        }
        
//        NSLog(@"point: %i",point);
        
        CGPathAddCurveToPoint(path,
                              NULL,
                              firstControlPoint.x,
                              firstControlPoint.y,
                              secondControlPoint.x,
                              secondControlPoint.y,
                              currentPoint.x,
                              currentPoint.y);
    }
    

    
    CGPathCloseSubpath(path);
    
    
    return path;
}

- (CGPoint)firstControlPointBetweenCurrentPoint:(CGPoint)currentPoint
                                       prePoint:(CGPoint)prePoint{
    CGPoint result = CGPointZero;
    
    CGFloat firstControlPointX = prePoint.x + self.controlPiontOffset;
    CGFloat firstControlPointY = prePoint.y + self.controlPiontOffset * (currentPoint.y - prePoint.y) / (currentPoint.x - prePoint.x);
    
    result = CGPointMake(firstControlPointX,
                         firstControlPointY);
    
    return result;
}

- (CGPoint)secondControlPointBetweenCurrentPoint:(CGPoint)currentPoint
                                       nextPoint:(CGPoint)nextPoint{
    CGPoint result = CGPointZero;

    CGFloat secondControlPointX = currentPoint.x - self.controlPiontOffset;
    CGFloat secondControlPointY = currentPoint.y - self.controlPiontOffset * (nextPoint.y - currentPoint.y) / (nextPoint.x - currentPoint.x);
    
    result = CGPointMake(secondControlPointX,
                         secondControlPointY);
    
    return result;
}


- (CGPoint)pointForPointIndex:(NSInteger)point
                       onLine:(NSInteger)line{
    
    CGPoint result = CGPointZero;
    
    NSInteger pointCount = [self.dataSource numberOfPointsOnLineInChartView:self];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:point inSection:line];
    float value = [self.dataSource chartView:self valueForPointAtIndexPath:indexPath];
    CGFloat pointX = self.bounds.size.width * point / (pointCount - 1);
    CGFloat pointY = self.bounds.size.height * value / self.maxCoordinateVerticalValue;
    
    result = CGPointMake(pointX,
                         pointY);
    
    return result;
}



#pragma mark - Property Method

- (float)maxPointValue{
    
    float result = 0;
    
    if (self.dataSource != nil) {
        
        NSInteger lineCount = [self.dataSource numberOfLinesInChartView:self];
        NSInteger pointCount = [self.dataSource numberOfPointsOnLineInChartView:self];
        
        NSInteger line = 0;
        for (line = 0;
             line < lineCount;
             line++) {
            
            NSInteger point = 0;
            for (point = 0;
                 point < pointCount;
                 point++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:point
                                                             inSection:line];
                float pointValue = [self.dataSource chartView:self
                                     valueForPointAtIndexPath:indexPath];
                
                result = MAX(result, pointValue);
            }
            
        }
        
    }
    
    NSLog(@"maxPointValue: %.2f", result);
    
    return result;
}

- (NSInteger)maxCoordinateVerticalValue{
    
    if (_maxCoordinateVerticalValue == 0) {
        
        float maxPointValue = [self maxPointValue];
        NSInteger intValueLength = [self lengthOfIntValue:(int)maxPointValue];
        // unitValue = 10^n for exmple : 100 or 1000 or 10000
        NSInteger unitValue = powf(10, intValueLength-1);
        NSInteger n = 1 + (int)(maxPointValue / unitValue);
        _maxCoordinateVerticalValue = n * unitValue;
    }
    
    
    NSLog(@"maxCoordinateVerticalValue: %li", (long)_maxCoordinateVerticalValue);
    return _maxCoordinateVerticalValue;
}

- (NSInteger)lengthOfIntValue:(int)intValue{
    
    NSInteger result = 0;
    NSString *intString = [NSString stringWithFormat:@"%i",intValue];
    result = [intString length];
    
    NSLog(@"lengthOfIntValue: %li", (long)result);
    return result;
    
}

- (CGFloat)controlPiontOffset{
    
    if (_controlPiontOffset == 0) {
        float lineJionSmooth = 0.5;
        NSInteger pointCount = [self.dataSource numberOfPointsOnLineInChartView:self];
        _controlPiontOffset = self.bounds.size.width / (pointCount -1) * lineJionSmooth;
    }
    return _controlPiontOffset;
}



@end
