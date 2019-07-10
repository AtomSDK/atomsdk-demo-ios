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
 If set to YES, alwaysOnEnable or connectOnDemandMatchDomains rules will be applied. Default value is NO.
 */
@property (nonatomic, assign) BOOL onDemandRulesEnabled;

/*!
@abstract
 Toggles VPN Always On feature. If true VPN connected automatically when connected with stable internet. Default is NO.
 */
@property (nonatomic, assign) BOOL alwaysOnEnable;


/*!
 * @property connectOnDemandMatchDomains
 * @discussion An array of web domain objects. e.g: www.domainname.com
 */
@property (nonatomic, strong) NSArray *connectOnDemandMatchDomains;


/*!
 * @property connectOnDemandMatchDomains
 * @discussion connect With VPN when wifi is connected to any of the following ssid e.g: www.domainname.com
 */
@property (nonatomic, strong) NSArray *unTrustedWifi;

/*!
 * @property connectOnDemandMatchDomains
 * @discussion disconnect  VPN when wifi is connected to any of the following ssid e.g: www.domainname.com
 */
@property (nonatomic, strong) NSArray *trustedWifi;


@end
