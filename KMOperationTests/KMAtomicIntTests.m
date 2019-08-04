//
//  KMAtomicIntTests.m
//  KMOperationTests
//
//  Created by kian on 6/23/19.
//  Copyright © 2019 Kian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KMAtomicInt.h"
#include <pthread.h>


#define NUMBER_OF_THREADS 1000

@interface KMAtomicIntTests : XCTestCase
@property (nonatomic, strong) KMAtomicInt *acnt;
@end

@implementation KMAtomicIntTests

- (void)setUp {
    _acnt = [[KMAtomicInt alloc] init:0];
}

- (void) increment;
{
    for(int n = 0; n < 1000; ++n) {
        [_acnt incrementAndGet];
    }
}

void* increment(void *args) {
    KMAtomicIntTests *tests = (__bridge KMAtomicIntTests*) args;
    [tests increment];
    return NULL;
}

- (void)testAll {
    
    pthread_t threads[NUMBER_OF_THREADS];
    for(int i=0; i < NUMBER_OF_THREADS; i++ ){
        pthread_create(&threads[i], NULL, increment, (__bridge void *)(self));
    }
    for(int i=0; i < NUMBER_OF_THREADS; i++ ){
        pthread_join(threads[i], NULL);
    }
    XCTAssertEqual(_acnt.value, 1000000);
}


@end
