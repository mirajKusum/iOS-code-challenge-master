//
//  YLPBusiness.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/21/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "YLPBusiness.h"

@implementation YLPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if(self = [super init]) {
        _identifier = attributes[@"id"];
        _name = attributes[@"name"];
        _rating = [attributes[@"rating"] doubleValue];
        _reviewCount = [attributes[@"review_count"] integerValue];
        _distance = [attributes[@"distance"] doubleValue];
        _price = attributes[@"price"];
        _imageURLString = attributes[@"image_url"];
        _categories = attributes[@"categories"];
        _isFavorite = attributes[@"isFavorite"] != nil ? attributes[@"isFavorite"] : false;
    }
    
    return self;
}

@end
