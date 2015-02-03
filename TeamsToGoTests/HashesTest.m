//
//  HashesTest.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Hashes.h"

@interface HashesTest : XCTestCase

@end

@implementation HashesTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}


- (void)testSHA1Hash {
    NSString *word = @"hello world";
    NSString *encrypted = @"2aae6c35c94fcfb415dbe95f408b9ce91ee846ed";
    NSString *hashed = [[Hashes alloc] sha1:word];
    XCTAssert([hashed isEqualToString:encrypted]);
    
}


@end
