//
//  Message.m
//  TeamsToGo
//
//  Created by Pho Diep on 3/12/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Message.h"

@interface Message ()

@property (strong, nonatomic) NSString *messageId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *postedBy;



@end

@implementation Message

-(instancetype)initWithJson:(NSDictionary*)json {
    self = [super init];
    if (self) {
        self.messageId = json[@"messageId"];
        self.title = json[@"title"];
        self.body = json[@"bodyText"];
        
        NSDictionary *postUser = json[@"postedBy"];
        self.postedBy = postUser[@"fullName"];
        
    }
    return self;
}

-(NSArray*)arrayOfMessagesWithJson:(NSArray*)messages {
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (NSDictionary *json in messages) {
        [results addObject: [[Message alloc] initWithJson:json]];
    }
    return results;
}

@end
