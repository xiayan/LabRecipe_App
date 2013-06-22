//
//  Buffer.m
//  LabRecipes
//
//  Created by Yan Xia on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Buffer.h"
@implementation Buffer

@dynamic bufferInstruction;
@dynamic bufferIsMolar;
@dynamic bufferMagnitude;
@dynamic bufferMW;
@dynamic bufferName;
@dynamic bufferStockConc;
@dynamic bufferUnit;
@dynamic bufferVolume;
@dynamic bufferVolumeMagnitude;
@dynamic bufferVolumeUnit;
@dynamic bufferIsSolid;

@end
@implementation Buffer (Calculation)
static int counter = 0;

- (double)scaleNumberUp:(double)aNumber {
    if (aNumber >= 1 || aNumber == 0.0) {
        return aNumber;
    } else {
        aNumber *= 1e3;
        counter += 1;
        return [self scaleNumberUp:aNumber];
    }
}

- (NSString *)calculateWeight {
    BOOL generateString = YES;
    NSString *resultUnit = nil;
    NSString *resultString = nil;
    NSString *emptyString = @"";
    double answer = 0.0;
    
    // Deal with empty attributes
    int missingFields = 0;
    if (self.bufferMW == nil || [self.bufferMW floatValue] == 0.0) {
        generateString = NO;
        emptyString = [emptyString stringByAppendingString:@"\"MW\""];
        missingFields += 1;
    } 
    if (self.bufferVolume == nil || [self.bufferVolume floatValue] == 0.0) {
        generateString = NO;
        emptyString = [emptyString stringByAppendingString:@" \"Volume\""];
        missingFields += 1;
    } 
    if (self.bufferStockConc == nil || [self.bufferStockConc floatValue] == 0.0) {
        generateString = NO;
        emptyString = [emptyString stringByAppendingString:@" \"Conc\""];
        missingFields += 1;
    }
    if (!generateString) {
        NSString *fieldWord = (missingFields == 1)? @" field " : @" fields ";
        NSString *verbWord = (missingFields == 1) ? @" is " : @" are ";
        emptyString = [emptyString stringByAppendingString:fieldWord];
        emptyString = [emptyString stringByAppendingString:verbWord];
        emptyString = [emptyString stringByAppendingString:@" empty"];
        return emptyString;
    }
    
    if ([self.bufferIsMolar boolValue]) {
        answer = [self.bufferMW doubleValue] * [self.bufferVolume doubleValue] * [self.bufferStockConc doubleValue] * [self.bufferVolumeMagnitude doubleValue] * [self.bufferMagnitude doubleValue];
    } else {
        answer = [self.bufferStockConc doubleValue] * [self.bufferVolume doubleValue] * [self.bufferVolumeMagnitude doubleValue] * [self.bufferMagnitude doubleValue];
    }
    
    // Format the answer number
    counter = 0;
    answer = [self scaleNumberUp:answer];
    
    switch (counter) {
        case 0:
            resultUnit = @"g";
            break;
        case 1:
            resultUnit = @"mg";
            break;
        case 2:
            resultUnit = @"μg";
            break;
        case 3:
            resultUnit = @"ng";
            break;
        case 4:
            resultUnit = @"fg";
            break;
        default:
            break;
    }
    NSString *name;
    if (self.bufferName == nil || [self.bufferName isEqualToString:@""]) {
        name = @"reagent";
    } else {
        name = self.bufferName;
    }
    
    resultString = [NSString stringWithFormat:@"Dissolve %.5g%@ %@ in %.5g%@ solvent", answer, resultUnit, name, [self.bufferVolume floatValue], [self bufferVolumeUnit]];
    
    return resultString;
}

- (NSString *)calculateDilution:(Buffer *)tempBuffer {
    NSString *message = nil;
    float ownConc, ownConcMag, sharingMW;
    float tempConc, tempConcMag, tempVol, tempVolMag;
    
    ownConc = [self.bufferStockConc floatValue];
    ownConcMag = [self.bufferMagnitude floatValue];
    sharingMW = [self.bufferMW floatValue];
    
    tempConc = [tempBuffer.bufferStockConc floatValue];
    tempConcMag = [tempBuffer.bufferMagnitude floatValue];
    tempVol = [tempBuffer.bufferVolume floatValue];
    tempVolMag = [tempBuffer.bufferVolumeMagnitude floatValue];
    
    if ([self.bufferIsMolar boolValue] && ![tempBuffer.bufferIsMolar boolValue]) {
        // transfering M to g/l
        ownConc = ownConc * ownConcMag * sharingMW;
    } else if (![self.bufferIsMolar boolValue] && [tempBuffer.bufferIsMolar boolValue]) {
        // transfering g/l to M
        ownConc = ownConc * ownConcMag / sharingMW;
    }
    // After aboving steps, the units of the two are equal
    
    float stockAmount = ownConc * ownConcMag;
    float tempAmount = tempConc * tempVol * tempConcMag * tempVolMag;
    float volume = tempAmount / stockAmount;
    float tempVolume = tempVol * tempVolMag;
    
    /*
     float stockAmount = [self.bufferStockConc floatValue] * [self.bufferMagnitude floatValue];
     float tempAmount = [tempBuffer.bufferStockConc floatValue] * [tempBuffer.bufferVolume floatValue]
     * [tempBuffer.bufferMagnitude floatValue] * [tempBuffer.bufferVolumeMagnitude floatValue];
     float volume = tempAmount / stockAmount;
     float tempVolume = [tempBuffer.bufferVolume floatValue] * [tempBuffer.bufferVolumeMagnitude floatValue];
     */
    
    if (volume >= tempVolume) {
        message = @"Final Concentration is higher than the stock";
    } else {
        // Format the answer number
        counter = 0;
        NSString *resultUnit;
        volume = [self scaleNumberUp:volume];
        
        switch (counter) {
            case 0:
                resultUnit = @"L";
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
            default:
                break;
        }
        
        message = [NSString stringWithFormat:@"Dilute %.5g%@ Stock to %.5g%@ solvent", volume, resultUnit,[tempBuffer.bufferVolume floatValue], [tempBuffer bufferVolumeUnit]];
    }
    
    return message;
}   

@end