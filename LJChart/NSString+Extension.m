//
//  NSString+Extension.m
//  LJChart
//
//  Created by Beeth0ven on 3/12/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


- (void)drawInMacCoordinateAtPoint:(CGPoint)point
                      withAttributes:(NSDictionary *)attributes{
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat pointY = point.y;
    
    CGContextSaveGState(currentContext);
    
    CGContextScaleCTM(currentContext,
                      1.0f,
                      -1.0f);
    
    CGContextTranslateCTM(currentContext,
                          0.0f,
                          -2 * pointY);
    
    [self drawAtPoint:point
       withAttributes:attributes];
    
    CGContextRestoreGState(currentContext);
    
}


@end
