//
//  LoginViewControllerTest.m
//  touch
//
//  Created by Ariel Xin on 3/12/15.
//  Copyright (c) 2015 cs48. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LoginViewController.h"

@interface LoginViewControllerTest : XCTestCase

@end

@implementation LoginViewControllerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testUsernameLength{
    LoginViewController *login = [[LoginViewController alloc] init];
    NSUInteger length = login.userNameField.text.length;
    XCTAssertGreaterThan(length, 4);
}

-(void) testPasswordLength{
    LoginViewController *login = [[LoginViewController alloc] init];
    NSUInteger length = login.passwordField.text.length;
    XCTAssertGreaterThan(length, 6);
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
