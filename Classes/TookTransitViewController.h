//
//  TookTransitViewController.h
//  Cycle Philly
//
//  Created by kat on 4/19/14.
//
//

#import <UIKit/UIKit.h>
#import "TripPurposeDelegate.h"

@interface TookTransitViewController : UIViewController
{
	UIView      *tookTransitView;
    UILabel     *transitText;
    UILabel     *answerTransitYesNo;
    UISwitch    *tookPublicTransit;
    UILabel     *rentalText;
    UILabel     *answerRentalYesNo;
    UISwitch    *tookRental;

    
    id <TripPurposeDelegate> delegate;
    IBOutlet UINavigationBar *navBarItself;
}

<<<<<<< HEAD
@property (nonatomic, retain) IBOutlet UIView *tookTransitView;
@property (nonatomic, retain) IBOutlet UILabel *transitText;
@property (nonatomic, retain) IBOutlet UILabel * answerTransitYesNo;
@property (nonatomic, retain) IBOutlet UISwitch *tookPublicTransit;
@property (nonatomic, retain) IBOutlet UILabel *rentalText;
@property (nonatomic, retain) IBOutlet UILabel * answerRentalYesNo;
@property (nonatomic, retain) IBOutlet UISwitch *tookRental;
@property (nonatomic, retain) id <TripPurposeDelegate> delegate;
=======
@property (nonatomic, strong) IBOutlet UIView *tookTransitView;
@property (nonatomic, strong) IBOutlet UILabel *descriptionText;
@property (nonatomic, strong) IBOutlet UILabel * answerYesNo;
@property (nonatomic, strong) IBOutlet UISwitch *tookPublicTransit;
@property (nonatomic, strong) id <TripPurposeDelegate> delegate;
>>>>>>> master

-(IBAction)cancel:(id)sender;
-(IBAction)saveDetail:(id)sender;
-(IBAction)answerChanged:(UISwitch *)sender;

@end