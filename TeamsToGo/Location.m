//
//  Location.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/14/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Location.h"

@interface Location ()

@property (strong, nonatomic) NSString *locationId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *partOfTown;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *googleMapsUrl;
@property (strong, nonatomic) NSString *comments;

@end

@implementation Location

-(instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    
    if (self) {
        self.locationId = json[@"locationId"];
        self.name = json[@"name"];
        self.partOfTown = json[@"address"][@"partOfTown"];
        self.address = json[@"address"][@"displaySingleLine"];
        self.googleMapsUrl = json[@"address"][@"googleMapsUrl"];
        self.comments = json[@"comments"];
        
    }
    return self;
}

-(NSString*)locationId {
    return self.locationId;
}

-(NSString*)name {
    return self.name;
}

-(NSString*)partOfTown {
    return self.partOfTown;
}

-(NSString*)address {
    return self.address;
}

-(NSString*)googleMapsUrl {
    return self.googleMapsUrl;
}

-(NSString*)comments {
    return self.comments;
}

@end
