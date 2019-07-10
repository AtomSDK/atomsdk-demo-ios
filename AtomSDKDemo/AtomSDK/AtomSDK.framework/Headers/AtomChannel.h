//
//  AtomChannel.h
//  AtomSDK Demo iOS App
//
//  Created by Taha Siddiqui on 5/29/19.
//

#import <Foundation/Foundation.h>

/*!
 * @interface AtomCity
 * @discussion Represents a City.
 */

@interface AtomChannel : NSObject

/*!
 * @property channelId
 * @discussion Gets or sets the integer id of the channel. The valid Channel id is required for VPN Dialing.
 */
@property (nonatomic) int channelId ;

/*!
 * @property name
 * @discussion Gets or sets the name of the channel.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @property channel_url
 * @discussion Gets or sets the web url of the channel.
 */
@property (nonatomic, strong) NSString *channel_url;

/*!
 * @property order
 * @discussion Gets or sets the sort order of the channel.
 */
@property (nonatomic) int order;

/*!
 * @property icon_url
 * @discussion Gets or sets the Icon Url of the channel.
 */
@property (nonatomic) NSString *icon_url;



@end
