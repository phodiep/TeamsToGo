//
//  Hashes.h
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hashes : NSString

//@property (nonatomic, readonly) NSString *sha1;
- (NSString *)sha1:(NSString *)str;

@end
