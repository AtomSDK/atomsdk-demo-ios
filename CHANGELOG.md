# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

### Version 6.0.3

#### Updated
- Remove / Suppress The Warnings From SDK.

### Version 6.0.2

#### Fixed
- Fix Install Profile Issue On Runtime Remove Profile.

### Version 6.0.1

#### Added
- Add Privacy Info Manifest File As Per Apple Requirements.

### Version 6.0.0

#### Added
- Compatibility for tvOS.
- Call an API for disconnection on CoC from WireGuard.
- `User-Agent` customisation in all Atom SDK APIs.
- Handling of `TAG_OVPN_OBF` and `TAG_QR` in `aTagFilter`.

#### Fixed
- No recommended protocol found in inventory for macOS lower than 10.15.
- Facing 404 on invalid URLs of country, protocol, and data centers when s3 call fails.
- DedicatedVPS UTC Connection Loop Fix.

### Version 5.2.4

#### Added
- Added the license file.

### Version 5.2.3

#### Added
- Handling for WireGuard UTC case.

#### Fixed
- Issue where the app did not disconnect on UTC while the adapter was disconnected.
- Handling of error code 40003 from speed test.

### Version 5.2.2

#### Changed
- Renamed class from `PolicyResponse` to `AtomSDKPolicyResponse`.
- Minimum deployment target for macOS updated from 10.12 to 10.13.

### Version 5.2.1

#### Added
- Hotfix for `nslookup` issues:
  - Addresses instances where some DNS are blocked during `nslookup`.

#### Fixed
- Exception handling for API responses:
  - Specifically, when the response status key's body contains an empty array.

### Version 5.2.0

#### Added
- Dialing feature for `DedicatedVPS`.
- Enhanced protocol selection:
  - In scenarios where a "recommended protocol" is applicable, the system now considers the policy JSON recommended protocol.

### Version 5.1.0

#### Added
- New error code:
  - `AtomSDKErrorVPNProfilePermissionDenied`: For Dedicated IP case scenarios.

#### Fixed
- Crash due to bounds exception when connecting via SmartConnect.
- Protocol switch handling improvements for the "Automatic" protocol in scenarios involving multiple DNS.

### Version 5.0.1

#### Added
- New property in `AtomConfiguration`:
  - `disableAnalytics`: Disables Mixpanel integration. Default value is `false`.



