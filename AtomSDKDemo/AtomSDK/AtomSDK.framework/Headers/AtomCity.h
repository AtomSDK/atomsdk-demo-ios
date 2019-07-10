//
//  AtomCity.h
//  AtomSDK Demo iOS App
//
//  Created by Taha Siddiqui on 6/3/19.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCity
 * @discussion Represents a City.
 */
@interface AtomCity : NSObject


/*!
 * @property cityId
 * @discussion Gets or sets the integer id of the city. The valid city id is required for VPN Dialing.
 */
@property (nonatomic) int cityId;

/*!
 * @property name
 * @discussion Gets or sets the name of the city.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property countryId
 * @discussion Gets or sets the country id of country with which city belongs. The valid country id is required for VPN Dialing.
 */
@property (nonatomic) int countryId;

/*!
 * @property dataCenters
 * @discussion Gets the failovers of this channel.
 */
@property (nonatomic) NSArray *data_centers;

@end

