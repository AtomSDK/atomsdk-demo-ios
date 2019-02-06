//
//  PopOverViewController.m
//  AtomSDK Demo

#import "PopOverViewController.h"
#import "PopOverViewController.h"

@interface PopOverViewController () <UIPopoverPresentationControllerDelegate>
@property (nonatomic) IBOutlet UILabel *labelTooltipText;
@end

@implementation PopOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTooltipText.text = self.tooltipText;
}

@end
