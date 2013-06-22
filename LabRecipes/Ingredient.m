//
//  Ingredient.m
//  LabRecipes
//
//  Created by Yan Xia on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Ingredient.h"
#import "Recipe.h"


@implementation Ingredient

@dynamic displayOrder;
@dynamic ingredientConc;
@dynamic ingredientFinalConc;
@dynamic ingredientName;
@dynamic ingredientUnit;
@dynamic ingredientMagnitude;
@dynamic ingredientFinalUnit;
@dynamic ingredientFinalMagnitude;
@dynamic isMolar;
@dynamic finalIsMolar;
@dynamic recipe;

static int counter = 0;

- (double)scaleNumberUp:(double)aNumber {
    if (aNumber >= 1 || aNumber <= 0.0) {
        return aNumber;
    } else {
        aNumber *= 1e3;
        counter += 1;
        return [self scaleNumberUp:aNumber];
    }
}

- (NSString *)calculateDilution:(double)finalVolume {

    NSString *message = nil;
    double conc, finalConc, mag, finalMag, vol;
    conc = [self.ingredientConc doubleValue];
    finalConc = [self.ingredientFinalConc doubleValue];
    mag = [self.ingredientMagnitude doubleValue];
    finalMag = [self.ingredientFinalMagnitude doubleValue];
    
    vol = finalConc * finalMag * finalVolume / conc / mag;
    if (vol >= finalVolume) {
        message = @"Final Too High";
    } else {
        NSString *resultUnit;
        counter = 0;
        vol = [self scaleNumberUp:vol];
        
        switch (counter) {
            case 0:
                resultUnit = @"g";
                break;
            case 1:
                resultUnit = @"mL";
                break;
            case 2:
                resultUnit = @"μL";
                break;
            case 3:
                resultUnit = @"nL";
                break;
            case 4:
                resultUnit = @"fL";
                break;
            default:
                break;
        }
        message = [NSString stringWithFormat:@"%.5g%@ stock", vol, resultUnit];
    }
    return message;
}

@end
