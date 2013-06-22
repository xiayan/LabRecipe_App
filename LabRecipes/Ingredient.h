//
//  Ingredient.h
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Ingredient : NSManagedObject

@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSString * ingredientConc;
@property (nonatomic, retain) NSString * ingredientFinalConc;
@property (nonatomic, retain) NSString * ingredientName;
@property (nonatomic, retain) NSString * ingredientUnit;
@property (nonatomic, retain) NSNumber * ingredientMagnitude;
@property (nonatomic, retain) NSString * ingredientFinalUnit;
@property (nonatomic, retain) NSNumber * ingredientFinalMagnitude;
@property (nonatomic, retain) NSNumber * isMolar;
@property (nonatomic, retain) NSNumber * finalIsMolar;
@property (nonatomic, retain) Recipe *recipe;

- (NSString *)calculateDilution:(double)finalVolume;

@end
