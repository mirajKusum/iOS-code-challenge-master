//
//  YLPBusiness.h
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface YLPBusiness : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

/**
 *  Yelp id of this business.
 */
@property (nonatomic, readonly, copy) NSString *identifier;

/**
 *  Name of this business.
 */
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSArray *categories;
@property (nonatomic, readonly, assign) NSInteger reviewCount;
@property (nonatomic, readonly, assign) double rating;
@property (nonatomic, readonly, assign) double distance;
@property (nonatomic, readonly, copy) NSString *imageURLString;
@property (nonatomic, readonly, copy) NSString *price;
@property (nonatomic, assign) BOOL isFavorite;

@end

NS_ASSUME_NONNULL_END
