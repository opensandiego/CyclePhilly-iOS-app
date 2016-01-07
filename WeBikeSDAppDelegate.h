//
//  AppDelegate.h
//  WeBikeSD
//
//  Created by Tyler Rogers on 12/29/15.
//
//

#import <CoreLocation/CoreLocation.h>

@interface WeBikeSDAppDelegate : NSObject <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    UIWindow *window;
    UITabBarController *tabBarController;
    NSString *uniqueIDHash;
    //UIAlertView *consentFor18;
    // added to handle location manager background service switching
    BOOL isRecording;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSString *uniqueIDHash;
//@property (nonatomic, retain) UIAlertView *consentFor18;
// added to handle location manager background service switching
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (NSString *)applicationDocumentsDirectory;
- (void)initUniqueIDHash;

@end