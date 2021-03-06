//
//  JWTParser.swift
//  BindID Example
//
//  Created by Shachar Udi on 07/10/2021.
//

import Foundation

class JWTParser {
    
    public static let shared = JWTParser()
    private let kNoDateString = "Never"
    private let kNoStringString = "Not Set"
    
    private init() { } // Prevent creating new instances of this singleton
    
    public enum IDTokenKeys: String {
        case email = "email"
        case bindIDNetworkInfo = "bindid_network_info"
        case bindIDInfo = "bindid_info"
        case sub = "sub"
        case bindIDAlias = "bindid_alias"
        case userRegistrationTime = "user_registration_time"
        case firstLogin = "capp_first_login"
        case firstConfirmedLogin = "capp_first_confirmed_login"
        case cappLastLogin = "capp_last_login"
        case userLastSeen = "user_last_seen"
        case confirmedCappCount = "confirmed_capp_count"
        case lastLoginFromAuthenticatedDevice = "capp_last_login_from_authenticating_device"
        case bindIDAppBoundCred = "ts.bindid.app_bound_cred"
        case authenticatedDeviceLastSeen = "authenticating_device_last_seen"
        case deviceCount = "device_count"
    }
    
    public func parseIDTokenData(_ tokenData: [String: Any]) -> [String: String] {
        var passport: [String: String] = [:]
        
        let networkInfo = tokenData[IDTokenKeys.bindIDNetworkInfo.rawValue] as? [String: Any]
        let bindIDInfo = tokenData[IDTokenKeys.bindIDInfo.rawValue] as? [String: Any]

        passport["User ID"] = tokenData[IDTokenKeys.sub.rawValue] as? String
        passport["User Alias"] = tokenData[IDTokenKeys.bindIDAlias.rawValue] as? String ?? kNoStringString
        passport["Email"] = tokenData[IDTokenKeys.email.rawValue] as? String ?? kNoStringString

        passport["User Registered On"] = networkInfo?[IDTokenKeys.userRegistrationTime.rawValue] as? String
        passport["User First Seen"] = formatTimestamp(bindIDInfo?[IDTokenKeys.firstLogin.rawValue] as? Double)
        passport["User First Confirmed"] = formatTimestamp(bindIDInfo?[IDTokenKeys.firstConfirmedLogin.rawValue] as? Double)
        passport["User Last Seen"] = formatTimestamp(bindIDInfo?[IDTokenKeys.cappLastLogin.rawValue] as? Double)
        passport["User Last Seen by Network"] = networkInfo?[IDTokenKeys.userLastSeen.rawValue] as? String
        passport["Total Providers that Confirmed User"] = "\(networkInfo?[IDTokenKeys.confirmedCappCount.rawValue] as? Int ?? 0)"
        passport["Authenticating Device Registered"] = formatTimestamp(bindIDInfo?[IDTokenKeys.lastLoginFromAuthenticatedDevice.rawValue] as? Double)
        
        let acr = tokenData["acr"] as? [String] ?? []
        passport["Authenticating Device Confirmed"] = acr.contains(IDTokenKeys.bindIDAppBoundCred.rawValue) ? "Yes" : "No"
        
        passport["Authenticating Device Last Seen"] = formatTimestamp(bindIDInfo?[IDTokenKeys.lastLoginFromAuthenticatedDevice.rawValue] as? Double)
        
        passport["Authenticating Device Last Seen by Network"] = networkInfo?[IDTokenKeys.authenticatedDeviceLastSeen.rawValue] as? String ?? kNoStringString
        passport["Total Known Devices"] = "\(networkInfo?[IDTokenKeys.deviceCount.rawValue] as? Int ?? 0)"
    
        return passport
    }
        
    private func formatTimestamp(_ timestamp: Double?) -> String {
        guard let date = timestamp?.date else { return kNoDateString }
        let dateformat = DateFormatter()
        dateformat.dateFormat = "EEEE, MMM d, yyyy"
        return dateformat.string(from: date)
    }
}
