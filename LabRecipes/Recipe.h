//
//  Recipe.h
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ingredient;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSNumber * recipeMagnitude;
@property (nonatomic, retain) NSString * recipeName;
@property (nonatomic, retain) NSString * recipeUnit;
@property (nonatomic, retain) NSString * recipeVolume;
@property (nonatomic, retain) NSSet *ingredients;

@end

@interface Recipe (CoreDataGeneratedAccessors)

- (void)addIngredientsObject:(Ingredient *)value;
- (void)removeIngredientsObject:(Ingredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

@end
