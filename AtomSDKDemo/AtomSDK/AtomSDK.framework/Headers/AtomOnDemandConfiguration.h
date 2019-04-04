//
//  AtomOnDemandConfiguration.h
//  AtomSDK Demo iOS App
//
//  Created by Gaditek on 26/02/2019.
//

#import <Foundation/Foundation.h>

@interface AtomOnDemandConfiguration : NSObject

/*!
 @abstract
 If set to YES, VPN connection auto-established when internet connection established. Default value is NO.
 */
@property (nonatomic, assign) BOOL onDemandRulesEnabled;

/*!
 * @property connectOnDemandRule
 * @discussion Toggles VPN Always On feature. If true VPN connected automatically. Default is false.
 */
@property (nonatomic, assign) BOOL connectOnDemandRule;


/*!
 * @property connectOnDemandMatchDomains
 * @discussion An array of web domain objects. e.g: www.domainname.com
 */
@property (nonatomic, strong) NSArray *connectOnDemandMatchDomains;

@end
