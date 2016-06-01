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
    UILabel     *descriptionText;
    UILabel     *answerYesNo;
    UISwitch    *tookPublicTransit;
    
    id <TripPurposeDelegate> delegate;
    IBOutlet UINavigationBar *navBarItself;
}

@property (nonatomic, strong) IBOutlet UIView *tookTransitView;
@property (nonatomic, strong) IBOutlet UILabel *descriptionText;
@property (nonatomic, strong) IBOutlet UILabel * answerYesNo;
@property (nonatomic, strong) IBOutlet UISwitch *tookPublicTransit;
@property (nonatomic, strong) id <TripPurposeDelegate> delegate;

-(IBAction)cancel:(id)sender;
-(IBAction)saveDetail:(id)sender;
-(IBAction)answerChanged:(UISwitch *)sender;

@end