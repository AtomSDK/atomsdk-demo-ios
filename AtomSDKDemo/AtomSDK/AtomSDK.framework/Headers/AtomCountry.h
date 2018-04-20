//
//  Country.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCountry
 * @discussion The AtomCountry class declares the programmatic interface of an object that manages the country-specific portion of a VPN configuration. This class will be used for getting the serverAdress of the VPN configuration.
 */
@interface AtomCountry : NSObject

/*!
 * @property countryId
 * @discussion The country id. Depending on the country.
 */
@property (nonatomic) int countryId;

/*!
 * @property name
 * @discussion The name. Depending on the country, the name of the country.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property iso_code
 * @discussion The iso code. Depending on the country, the iso code of the country.
 */
@property (nonatomic, strong) NSString *iso_code;

/*!
 * @property latitude
 * @discussion The latitude. Depending on the country.
 */
@property (nonatomic) double latitude;

/*!
 * @property longitude
 * @discussion The longitude. Depending on the country.
 */
@property (nonatomic) double longitude;

/*!
 * @property protocol
 * @discussion The protocol. Depending on the country. The values will be dependant upon the country provided for connection, representing the available protocols.
 */
@property (nonatomic) NSArray *protocol;

/*!
 * @property latency
 * @discussion The latency. Depending on the country, the latency of the country used to represent the current health of the country.
        Default value for this property will be 0 when calling through (Method) getCountriesWithSuccess:failure found in (Class) AtomManager. Otherwise this property will set to the value against the current VPN server health when calling through (Method) getOptimizedCountriesWithSuccess:failure found in (Class) AtomManager.
 */
@property (nonatomic) int latency;

@end
