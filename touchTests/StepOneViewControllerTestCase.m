//
//  StepOneViewControllerTestCase.m
//  touch
//
//  Created by Ariel Xin on 2/18/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "StepOneViewController.h"

@interface StepOneViewControllerTestCase : XCTestCase

@end

@implementation StepOneViewControllerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPasswordMatch{
    StepOneViewController *signup = [[StepOneViewController alloc] init];
    signup.password.text = @"123456";
    signup.confirmPW.text = @"123456";
    XCTAssertEqual(signup.password.text, signup.confirmPW.text,@"password match");
}

- (void)testPasswordDoNotMatch{
    StepOneViewController *signup = [[StepOneViewController alloc] init];
    signup.password.text = @"123456";
    signup.confirmPW.text = @"654321";
    int match = [signup.password.text isEqualToString:signup.confirmPW.text];
    XCTAssertEqual(match, 0,@"password do not match");
}


- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
