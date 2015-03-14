//
//  Location.h
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

-(instancetype)initWithJson:(NSDictionary*)json;

-(NSString*)locationId;
-(NSString*)name;
-(NSString*)partOfTown;
-(NSString*)address;
-(NSString*)googleMapsUrl;
-(NSString*)comments;


@end
