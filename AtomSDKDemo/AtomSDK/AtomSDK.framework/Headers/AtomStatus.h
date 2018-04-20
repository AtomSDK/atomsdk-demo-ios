//
//  AtomStatus.h
//  AtomSDK
//
//  Copyright © 2017 Atom. All rights reserved.
//

#ifndef AtomStatus_h
#define AtomStatus_h

/*!
 * @typedef AtomVPNStatus
 * @abstract AtomVPN status codes
 */

typedef NS_ENUM (NSInteger, AtomVPNState) {
    /*! @const AtomStatusInvalid The VPN is not configured. */
    AtomStatusInvalid,
    /*! @const AtomStatusDisconnected The VPN is disconnected. */
    AtomStatusDisconnected,
    /*! @const AtomStatusConnecting The VPN is connecting. */
    AtomStatusConnecting,
    /*! @const AtomStatusConnected The VPN is connected. */
    AtomStatusConnected,
    /*! @const AtomStatusReasserting The VPN is reconnecting following loss of underlying network connectivity. */
    AtomStatusReasserting,
    /*! @const AtomStatusDisconnecting The VPN is disconnecting. */
    AtomStatusDisconnecting,
    /*! @const AtomStatusValidation The VPN is Validating. */
    AtomStatusValidating,
    /*! @const GeneratingCredentials The VPN is disconnecting. */
    AtomStatusGeneratingCredentials,
    /*! @const AtomStatusGettingFastestServer The VPN is disconnecting. */
    AtomStatusGettingFastestServer,
    /*! @const OptimizingConnection The VPN is disconnecting. */
    AtomStatusOptimizingConnection,
    /*! @const AtomStatusVerifyingHostName The VPN is AtomStatusVerifyingHostName. */
    AtomStatusVerifyingHostName,
    /*! @const AtomStatusAuthenticating The VPN is AtomStatusAuthenticating. */
    AtomStatusAuthenticating
};
typedef void (^StateDidChangedHandler)(AtomVPNState status);

typedef NS_ENUM (NSInteger, AtomVPNStatus) {
    /*! @const DISCONNECTED The VPN is disconnected. */
    DISCONNECTED,
    /*! @const CONNECTING The VPN is connecting. */
    CONNECTING,
    /*! @const CONNECTED The VPN is connected. */
    CONNECTED
};

typedef void (^OnPacketsTransmitted)(NSNumber *bytesReceived , NSNumber *bytesSent);

#endif /* AtomStatus_h */
