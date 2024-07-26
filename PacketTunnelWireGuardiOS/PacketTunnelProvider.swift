//
/*
 * PacketTunnelProvider.swift
 * PacketTunnelWireGuardiOS
 
 * Created by AtomSDK on 26/07/2024.
 * Copyright © 2024 AtomSDK. All rights reserved.
 */

import NetworkExtension
import AtomWireGuardAppExtension

class PacketTunnelProvider: WireGuardTunnelProvider {
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Add code here to start the process of connecting the tunnel.
        super.startTunnel(options: options, completionHandler: completionHandler)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code here to start the process of stopping the tunnel.
        super.stopTunnel(with: reason, completionHandler: completionHandler)
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        // Add code here to handle the message.
        super.handleAppMessage(messageData, completionHandler: completionHandler)
    }
}
