//
//  Location.h
//  TeamsToGo
//
//  Created by Pho Diep on 4/5/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *partOfTown;
@property (strong, nonatomic) NSString *googleMapsUrl;
@property (strong, nonatomic) NSString *comments;


@end
