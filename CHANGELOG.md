
# Change Log
All notable changes to this project will be documented in this file.
 
The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

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



