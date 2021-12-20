//
//  BindID.swift
//  Runner
//
//  Created by Ran Stone on 07/12/2021.
//

import Foundation
import Flutter
import XmBindIdSDK

class BindID{
    
    private var host: String = ""
    public var idToken: String = ""
    internal var userPassport: [String: String] = [:]
    private let kNoDateString = "Never"
    
     func initBindId(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        
        guard let args = call.arguments as? Dictionary<String, Any>,
              let hostName = args["bindid_host"] as? String
        else {
            return result(FlutterError.init(code: "MISSING_PARAM", message: "Missing bindid_host", details: nil))
        }
        guard let args = call.arguments as? Dictionary<String, Any>,
              let clientID = args["bindid_client_id"] as? String else {
            return result(FlutterError.init(code: "MISSING_PARAM", message: "Missing bindid_client_id", details: nil))
        }
        
        host = hostName
        let config = XmBindIdConfig(serverEnvironment:
            XmBindIdServerEnvironment(environmentMode: XmBindIdServerEnvironmentMode.sandbox), clientId: clientID)

        XmBindIdSdk.shared.initialize(config: config) {(_, error) in
            if let e = error {
                result(FlutterError(code: "sdk_init_error",
                                        message: e.message ?? "unknown error",
                                        details: nil))
            } else {
                result("bindid_init_done")
            }
        }
    }

    func authenticate(call: FlutterMethodCall, result: @escaping FlutterResult) {
       
        guard let args = call.arguments as? Dictionary<String, Any>,
              let redirectUri = args["bindid_redirect_uri"] as? String else {
            return result(FlutterError.init(code: "MISSING_PARAM", message: "Missing bindid_redirect_uri", details: nil))
        }
         
        let request = XmBindIdAuthenticationRequest(redirectUri: redirectUri)
        request.usePkce = true
        request.scope = [.openId, .networkInfo, .email] // openId is the default configuration, you can also add .email, .networkInfo, .phone
        XmBindIdSdk.shared.authenticate(bindIdRequestParams: request) { [weak self] (response, error) in
            if let e = error {
                result(FlutterError(code: "sdk_authenticate_error",
                                        message: e.message ?? "unknown error",
                                        details: nil))
            } else if let requestResponse = response {
                self?.exchange(response: requestResponse, result: result)
            }
        }
    }

    func exchange (response: XmBindIdResponse, result: @escaping FlutterResult) {
        XmBindIdSdk.shared.exchangeToken(exchangeRequest: XmBindIdExchangeTokenRequest.init(codeResponse: response)) { [weak self] (response, error) in
            if let e = error {
                result(FlutterError(code: "sdk_exchange_error",
                                        message: e.message ?? "unknown error",
                                        details: nil))
            } else if let tokenResponse = response {
                self?.validateTokenResponse(tokenResponse, result: result)
            }
        }
    }

    func sendTokenToServer(idToken: String,accessToken: String) {
     // Add code to send the ID and access token to your application server here
    }

    // MARK:- Validate the Token Exchange Response

    private func validateTokenResponse(_ tokenResponse: XmBindIdExchangeTokenResponse, result: @escaping FlutterResult) {
        JWTValidator.shared.validate(tokenResponse.idToken, host: host) { [weak self] isValid, jwtValidationError in
            guard jwtValidationError == nil else {
                result(FlutterError(code: "sdk_validate_jwt_error",
                                        message: (jwtValidationError ?? "unknown error"),
                                        details: nil))
                return
            }
            self?.idToken = tokenResponse.idToken
            self?.handleJWTValidation(isValid: isValid, tokenResponse: tokenResponse, result: result)
        }
    }

    // MARK:- Handle JWT Validation results

    private func handleJWTValidation(isValid: Bool, tokenResponse: XmBindIdExchangeTokenResponse, result: @escaping FlutterResult) {
        guard isValid else {
            result(FlutterError(code: "sdk_validate_jwt_error",
                                    message: "The JWT (idToken) is not valid. Please check your configuration",
                                    details: nil))
            return
        }
         result(setPassportTableData())
         sendTokenToServer(idToken: tokenResponse.idToken, accessToken: tokenResponse.accessToken)

    }


    // MARK:-  Get the JWT token to display it in a user friendly format

    private func setPassportTableData() -> [String: String]{
        // Parse the ID token payload received from BindID to obtain information about the user
        guard let tokenData = try? JWTDecoder.shared.decodePayload(idToken) else {
            NSLog("Error decoding BindID Token: \(idToken)")
            return [:]
        }
        
        userPassport = JWTParser.shared.parseIDTokenData(tokenData)
        return userPassport
    }

}
