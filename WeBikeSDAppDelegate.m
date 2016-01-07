//
//  AppDelegate.m
//  WeBikeSD
//
//  Created by Tyler Rogers on 12/29/15.
//
//

#import <CommonCrypto/CommonDigest.h>


#import "WeBikeSDAppDelegate.h"
#import "PersonalInfoViewController.h"
#import "RecordTripViewController.h"
#import "SavedTripsViewController.h"
#import "TripManager.h"
#import "NSString+MD5Addition.h"
#import "UIDevice+IdentifierAddition.h"
#import "constants.h"
#import "DetailViewController.h"
#import <CoreData/NSMappingModel.h>


@implementation WeBikeSDAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize uniqueIDHash;
//@synthesize consentFor18;
@synthesize isRecording;
@synthesize locationManager;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // disable screen lock
    //[UIApplication sharedApplication].idleTimerDisabled = NO;
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
    }
    
    // init our unique ID hash
    [self initUniqueIDHash];
    
    // initialize trip manager with the managed object context
    TripManager *tripManager = [[[TripManager alloc] initWithManagedObjectContext:context] autorelease];
    
    //Anon Firebase User
    NSDateFormatter *formatter;
    NSString        *today;
    formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy/MM/dd/"];
    today = [formatter stringFromDate:[NSDate date]];
    NSMutableString *fireURLC = [[[NSMutableString alloc] initWithString:kFireDomain] autorelease];
    [fireURLC appendString:@"trips-completed/"];
    [fireURLC appendString:today];
    Firebase *ref = [[[Firebase alloc] initWithUrl:@"https://blazing-torch-4795.firebaseio.com/"] autorelease];
    
    
    [ref authAnonymouslyWithCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            // There was an error logging in anonymously
            NSLog(@"Firebase auth error!");
        } else {
            // We are now logged in!
            NSDictionary *newUser = @{
                                      @"provider": authData.provider,
                                      @"uid": authData.uid
                                      };
            [[[ref childByAppendingPath:@"users"]
              childByAppendingPath:authData.uid] setValue:newUser];
            
        }
    }];
    
    UINavigationController	*recordNav	= (UINavigationController*)[tabBarController.viewControllers
                                                                    objectAtIndex:0];
    //[navCon popToRootViewControllerAnimated:NO];
    RecordTripViewController *recordVC	= (RecordTripViewController *)[recordNav topViewController];
    [recordVC initTripManager:tripManager];
    
    
    UINavigationController	*tripsNav	= (UINavigationController*)[tabBarController.viewControllers
                                                                    objectAtIndex:1];
    //[navCon popToRootViewControllerAnimated:NO];
    SavedTripsViewController *tripsVC	= (SavedTripsViewController *)[tripsNav topViewController];
    tripsVC.delegate					= recordVC;
    [tripsVC initTripManager:tripManager];
    
    // select Record tab at launch
    tabBarController.selectedIndex = 0;
    
    // set delegate to prevent changing tabs when locked
    tabBarController.delegate = recordVC;
    
    // set parent view so we can apply opacity mask to it
    recordVC.parentView = tabBarController.view;
    
    UINavigationController	*nav	= (UINavigationController*)[tabBarController.viewControllers
                                                                objectAtIndex:2];
    PersonalInfoViewController *vc	= (PersonalInfoViewController *)[nav topViewController];
    vc.managedObjectContext			= context;
    
    
   	// Add the tab bar controller's current view as a subview of the window
    //[window addSubview:tabBarController.view];
  //  [window setRootViewController:tabBarController];
    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    
    
    //Clear out windows.  
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for(UIWindow *cleanWindow in windows) {
        NSLog(@"window: %@",cleanWindow.description);
        if(cleanWindow.rootViewController == nil){
            UIViewController* viewController = [[UIViewController alloc]initWithNibName:nil bundle:nil];
            cleanWindow.rootViewController = viewController;
        }
    }
    
    
    
}

- (void)initUniqueIDHash
{
    self.uniqueIDHash = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"Hashed uniqueID: %@", uniqueIDHash);
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"applicationWillTerminate: Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *) application
{
    WeBikeSDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(appDelegate.isRecording){
        NSLog(@"BACKGROUNDED and recording"); //set location service to startUpdatingLocation
        [appDelegate.locationManager startUpdatingLocation];
    } else {
        NSLog(@"BACKGROUNDED and sitting idle"); //set location service to startMonitoringSignificantLocationChanges
        [appDelegate.locationManager stopUpdatingLocation];
        //[appDelegate.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *) application
{
    //always turnon location updating when active.
    WeBikeSDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //[appDelegate.locationManager stoptMonitoringSignificantLocationChanges];
    [appDelegate.locationManager startUpdatingLocation];
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurre];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WeBikeSD" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CycleTracks.sqlite"]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, nil];
    //[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible
         * The schema for the persistent store is incompatible with current managed object model
         Check the error message to determine what the actual problem was.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.window = nil;
    self.tabBarController = nil;
    self.uniqueIDHash = nil;
    self.isRecording = nil;
    self.locationManager = nil;
    
    [tabBarController release];
    [uniqueIDHash release];
    [locationManager release];
    [window release];
    
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [super dealloc];
}


@end
