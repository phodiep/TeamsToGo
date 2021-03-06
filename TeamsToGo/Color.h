//
//  Color.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Color : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor*)headerColor;
+ (UIColor*)headerTextColor;

@end
