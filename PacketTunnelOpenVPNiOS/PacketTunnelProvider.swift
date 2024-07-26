//
/*
 * PacketTunnelProvider.swift
 * PacketTunnelOpenVPNiOS
 
 * Created by AtomSDK on 26/07/2024.
 * Copyright © 2024 AtomSDK. All rights reserved.
 */

import NetworkExtension
import AtomSDKTunnel

class PacketTunnelProvider: AtomPacketTunnelProvider {
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        super.startTunnel(options: options, completionHandler: completionHandler)
    }
}
