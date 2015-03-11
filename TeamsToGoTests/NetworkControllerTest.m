//
//  NetworkControllerTest.m
//  TeamsToGo
//
//  Created by Pho Diep on 2/2/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NetworkController.h"
#import "ApiKeys.h"

@interface NetworkControllerTest : XCTestCase

@property NetworkController *sharedInstance;
@property NetworkController *sharedInstance2;

@end

@implementation NetworkControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.sharedInstance = [NetworkController sharedInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testSharedInstance {
    self.sharedInstance2 = [NetworkController sharedInstance];
    XCTAssertEqual(self.sharedInstance, self.sharedInstance2);
}


- (void)testRequestSignature {
    NSString *requestName = @"GET";
    NSString *methodCall = @"Team_Get";
    NSArray *param = @[@"method=team_get"];

//    NSLog([self.sharedInstance requestSignature:requestName methodBeingCalled:methodCall parameters:param]);

    XCTAssertTrue(true);
}


@end
