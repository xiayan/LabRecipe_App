//
//  Buffer.h
//  LabRecipes
//
//  Created by Yan Xia on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buffer : NSManagedObject

@property (nonatomic, retain) NSString * bufferInstruction;
@property (nonatomic, retain) NSNumber * bufferIsMolar;
@property (nonatomic, retain) NSNumber * bufferMagnitude;
@property (nonatomic, retain) NSString * bufferMW;
@property (nonatomic, retain) NSString * bufferName;
@property (nonatomic, retain) NSString * bufferStockConc;
@property (nonatomic, retain) NSString * bufferUnit;
@property (nonatomic, retain) NSString * bufferVolume;
@property (nonatomic, retain) NSNumber * bufferVolumeMagnitude;
@property (nonatomic, retain) NSString * bufferVolumeUnit;
@property (nonatomic, retain) NSNumber * bufferIsSolid;

@end

@interface Buffer (Calculation)
- (NSString *)calculateWeight;
- (NSString *)calculateDilution:(Buffer *)tempBuffer;
@end