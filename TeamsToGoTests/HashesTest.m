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

- (void)testSHA1Hash {
    NSString *word = @"hello world";
    NSString *encrypted = @"2aae6c35c94fcfb415dbe95f408b9ce91ee846ed";
    NSString *hashed = [[Hashes alloc] sha1:word];
    XCTAssert([hashed isEqualToString:encrypted]);

    //test Teamcowboy's supplied example to confirm
    NSString *concatString = @"413abdc2120adb9a06eb13cf76483aa25d18dc5a|GET|Team_Get|1296268551|5646464564|api_key=b412e0601e179ad12df1a0ff5b8da12aafb74a3d&method=team_get&nonce=5646464564&teamId=1234&timestamp=1296268551&userToken=0bd5a0ed9ff7f4c59e1854b63b341a8f";
    NSString *encryptedString = @"420dbffb7136d0dab320a29d0d2e64ce8a27f7e7";
    NSString *hashedString = [[Hashes alloc] sha1:concatString];
    XCTAssert([hashedString isEqualToString:encryptedString]);


}



@end
