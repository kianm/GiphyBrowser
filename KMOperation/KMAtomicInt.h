//
//  KMAtomicInt.h
//  KMOperation
//
//  Created by kian on 6/22/19.
//  Copyright © 2019 Kian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KMAtomicInt : NSObject

- (instancetype) init:(NSInteger) value;
- (NSInteger)incrementAndGet;
- (NSInteger)decrementAndGet;
@property (nonatomic, assign, readonly) NSInteger value;

@end

NS_ASSUME_NONNULL_END
