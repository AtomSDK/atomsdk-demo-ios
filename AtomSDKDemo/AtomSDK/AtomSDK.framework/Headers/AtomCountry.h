//
//  Country.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCountry
 * @discussion Represents a Country.
 */
@interface AtomCountry : NSObject

/*!
 * @property countryId
 * @discussion Gets or sets the integer id of the country. The valid Country id is required for VPN Dialing.
 */
@property (nonatomic) int countryId;

/*!
 * @property name
 * @discussion Gets or sets the name of the country.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property iso_code
 * @discussion Gets or sets the ISO Alpha-2 Country code of the current country.
 */
@property (nonatomic, strong) NSString *iso_code;

/*!
 * @property latitude
 * @discussion Gets or sets the latitude of the country.
 */
@property (nonatomic) NSString *latitude;

/*!
 * @property longitude
 * @discussion Gets or sets the logitude of the country.
 */
@property (nonatomic) NSString *longitude;

/*!
 * @property protocol
 * @discussion Gets the protocols supported by this country.
 */
@property (nonatomic) NSArray *protocols;

/*!
 * @property dataCenters
 * @discussion The dataCenters. Depending on the country. The values will be dependant upon the country provided for connection, representing the available data centers.
 */
@property (nonatomic) NSArray *dataCenters;

/*!
 * @property latency
 * @discussion Gets or sets the least time a packet takes to be sent to the server of this country plus the length of time it takes for an acknowledgment of that packet to be received at the client depending on user's network conditions. Default value for this property is 0 when calling Countries
 */
@property (nonatomic) int latency;

/*!
 * @property isSmartDialingSupported
 * @discussion The isSmartDialingSupported. Property to identify which country is Smart Country.
 */
@property (atomic) BOOL isSmartDialingSupported;

@end
