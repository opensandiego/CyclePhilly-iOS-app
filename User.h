//
//  User.h
//  Cycle Atlanta
//
//  Created by Guo Anhong on 13-2-26.
//  adapted for CyclePhilly 2013, CodeforPhilly.org
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, Trip;

@interface User : NSManagedObject

<<<<<<< HEAD
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * cyclingFreq;
@property (nonatomic, retain) NSNumber * rider_history;
@property (nonatomic, retain) NSNumber * rider_type;
@property (nonatomic, retain) NSNumber * income;
@property (nonatomic, retain) NSNumber * ethnicity;
@property (nonatomic, retain) NSString * homeZIP;
@property (nonatomic, retain) NSString * schoolZIP;
@property (nonatomic, retain) NSString * workZIP;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSSet *trips;
=======
@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSNumber * cyclingFreq;
@property (nonatomic, strong) NSNumber * rider_history;
@property (nonatomic, strong) NSNumber * rider_type;
@property (nonatomic, strong) NSNumber * income;
@property (nonatomic, strong) NSNumber * ethnicity;
@property (nonatomic, strong) NSString * homeZIP;
@property (nonatomic, strong) NSString * schoolZIP;
@property (nonatomic, strong) NSString * workZIP;
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSSet *notes;
@property (nonatomic, strong) NSSet *trips;
>>>>>>> master
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTripsObject:(Trip *)value;
- (void)removeTripsObject:(Trip *)value;
- (void)addTrips:(NSSet *)values;
- (void)removeTrips:(NSSet *)values;

@end
