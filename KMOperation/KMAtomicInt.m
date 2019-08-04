//
//  KMAtomicInt.m
//  KMOperation
//
//  Created by kian on 6/22/19.
//  Copyright © 2019 Kian. All rights reserved.
//

#import "KMAtomicInt.h"
#import <stdatomic.h>

@implementation KMAtomicInt {
    volatile atomic_int underlying;
}


- (instancetype) init:(NSInteger) value;
{
    self = [super init];
    underlying = value;
    return self;
}

- (void) setValue:(NSInteger)value;
{
    underlying = value;
}

- (NSInteger) value;
{
    return underlying;
}

- (NSInteger)incrementAndGet;
{
    underlying++;
    return underlying;
}

- (NSInteger)decrementAndGet; 
{
    underlying--;
    return underlying;
}
@end
