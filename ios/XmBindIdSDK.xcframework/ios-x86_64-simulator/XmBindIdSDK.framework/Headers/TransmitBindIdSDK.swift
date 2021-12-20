/**
 * \file 
 * Copyright (C) Transmit Security, LTD - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Generated using tsidlc.
 * 
 * Package com.ts.bindid
 */

import Foundation
import CoreLocation



public let XmBindIdButtonClass = "xm-bind-id-button"

public let XmBindIdButtonOnFailureCallback = "data-xm-bind-id-on-failure"

public let XmBindIdButtonOnSuccessCallback = "data-xm-bind-id-on-success"

/** XmBindIdErrorCode
 BindId Client SDK error codes
 */
public enum XmBindIdErrorCode : String, CaseIterable, Equatable, Hashable, Codable {
   /** Attempt to call SDK functionality without proper SDK initialization. */ 
   case sdkNotInitialized
   /** SDK initialized with an invalid configuration. */ 
   case invalidConfig
   /** Returned when a response does not match an expected result. */ 
   case invalidResponse
   /** Returned when authentication was cancelled or rejected. */ 
   case accessDenied
   /** Returned when an internal server error occurred during the process. */ 
   case serverError
   /** (Mobile Only) Returned when the user cancels the alert asking for permission to login to this app, or dismisses the view controller for loading the authentication webpage. */ 
   case userCanceled
   /** (Mobile Only) Platform-specific errors (like a valid presentationContextProvider was not found when -start was called. Ensure this property was not nil when -start was called.) */ 
   case platformError
   /** (Mobile Only) No internet connection. */ 
   case internetConnection
   /** (Mobile Only) User isn't registered. Can only happen after calling authenticateBoundUser */ 
   case unknownUser
} 

/** XmBindIdApiCompatibilityLevel
 BindID Client SDK API compatibility selection enum.
 */
public enum XmBindIdApiCompatibilityLevel : String, CaseIterable, Equatable, Hashable, Codable {
   /** Always use the API behavior of the latest version. */ 
   case useLatest
   /** Use API Level 1 behavior. */ 
   case apiLevel1
} 

/** XmBindIdLoginHintType
 Available types for the login hint.
 */
public enum XmBindIdLoginHintType : String, CaseIterable, Equatable, Hashable, Codable {
   /** Indicates that the login hint value is an email address */ 
   case email
} 

/** XmBindIdBoundToType
 Available types of user identifiers used to validate that the device is bound to the Client Application for this user.
 */
public enum XmBindIdBoundToType : String, CaseIterable, Equatable, Hashable, Codable {
   /** Indicates that the user identifier is the subject of the ID token. */ 
   case sub
   /** Indicates that the user identifier is a user alias, represented in the ID token as `bindid_alias`. If used, it is highly recommended to encrypt the authentication request (via the `encrypted` parameter) to avoid potentially exposing sensitive information. */ 
   case alias
} 

/** XmBindIdScopeType
 Available BindID scopes.
 */
public enum XmBindIdScopeType : String, CaseIterable, Equatable, Hashable, Codable {
   /** Indicate that the application intends to use OIDC to verify the user's identity. This scope is required by BindID and will be added automatically by the SDK. */ 
   case openId
   /** Indicates that the application intends to ask for the user's email information. Additional email-related claims will be added to the ID Token. */ 
   case email
   /** Indicates that the application intends to ask for the user's phone information. Additional phone-related claims will be added to the ID Token. */ 
   case phone
   /** Indicates that the application intends to ask for user metadata across all providers integrated with BindID. The ID token will include additional claims, which provide user and device information collected in the context of all providers integrated with BindID. */ 
   case networkInfo
} 

/** XmRequiredVerifications
 Possible verifications to require during authentication.
 */
public enum XmRequiredVerifications : String, CaseIterable, Equatable, Hashable, Codable {
   /** If specified, BindID will attempt to ensure that the user's phone number is verified.If it's not, it will be verified during the login process. */ 
   case phone
   /** If specified, BindID will attempt to ensure that the user's email address is verified. If it's not, it will be verified during the login process.*/ 
   case email
} 

/** XmBindIdServerEnvironmentMode
 Available BindID Server Environment.
 */
public enum XmBindIdServerEnvironmentMode : String, CaseIterable, Equatable, Hashable, Codable {
   /** Indicate the production server URL path */ 
   case production
   /** Indicate the sandbox server URL path */ 
   case sandbox
    
   case other
} 

/**
 An object representing SDK errors or failed authentication errors.
 */
@objc(XmBindIdError)
public class XmBindIdError : NSObject, Codable { 

/**
 Error code representing what happened
 */
public internal (set) var code: XmBindIdErrorCode!

/**
 Error description
 */
public internal (set) var message: String!

/**
 A URI identifying a human-readable web page containing information about the error, if available.
 */
public internal (set) var errorUri: String?
}

/**
 Available BindID Server URL.
 */
@objc(XmBindIdServerEnvironment)
public class XmBindIdServerEnvironment : NSObject, Codable { 

/**
 BindID Server Environment.
 */
public var environmentMode: XmBindIdServerEnvironmentMode!

/**
 BindID Server URL.
 */
public var environmentUrl: String!

/**
 Creates an instance for the sandbox or production environment, and sets the relevant server URL.
 */
public init(environmentMode: XmBindIdServerEnvironmentMode) {
     super.init()
     self.environmentMode = environmentMode
}

/**
 Creates an instance for a custom server environment by specifying the server URL.
 */
public init(environmentUrl: String) {
     super.init()
     self.environmentUrl = environmentUrl
}
}

/**
 Application-wide configuration for the BindID Client SDK.
 */
@objc(XmBindIdConfig)
public class XmBindIdConfig : NSObject, Codable { 

/**
 Server URL for the BindID authentication.
 */
public var serverEnvironment: XmBindIdServerEnvironment!

/**
 BindID client ID as provisioned with the BindID service.
 */
public var clientId: String!

/**
 API Compatibility Level to use for the SDK.
 By fixing this value to a given API Level, SDK clients can signal that they want the
 SDK calls to behave as they behaved in that given API level. While this means
 that SDK behavior doesn't change, it also means that the applications may not benefit
 from updated SDK behavior. Clients are thus expected to periodically update the SDK
 API level they're interested in.
 If not provided, assumed level is 'latest'.
 */
public var apiCompat: XmBindIdApiCompatibilityLevel?

/**
 A flag indicating whether state sent on BindID Client SDK authenticate call
 is validated during processRedirectResponse.
 */
public var disableStateValidation: Bool?

public init(serverEnvironment: XmBindIdServerEnvironment, clientId: String) {
     super.init()
     self.serverEnvironment = serverEnvironment
     self.clientId = clientId
}

public init(clientId: String) {
     super.init()
     self.clientId = clientId
}
}

/**
 Type and value for the login hint, which is used as a hint for the user’s login identifier (e.g., their email address)
 */
@objc(XmBindIdLoginHint)
public class XmBindIdLoginHint : NSObject, Codable { 

public var type: XmBindIdLoginHintType!

public var value: String!

public init(type: XmBindIdLoginHintType, value: String) {
     super.init()
     self.type = type
     self.value = value
}
}

/**
 Used to require an authenticating device bound to the Client Application for a specified user (e.g., for step-up authentication). This bound status is reflected in the ID token by the `ts.bindid.app_bound_cred` ACR value, which is set using a session-feedback request.
 */
@objc(XmBindIdBoundTo)
public class XmBindIdBoundTo : NSObject, Codable { 

public var type: XmBindIdBoundToType!

public var value: String!

public init(type: XmBindIdBoundToType, value: String) {
     super.init()
     self.type = type
     self.value = value
}
}

/**
 Shared parameters for a BindID request configuration.
 */
@objc(XmBindIdRequest)
public class XmBindIdRequest : NSObject, Codable { 

/**
 URL to which BindID will redirect on process completion, to convey results back to the
 calling application.
 */
public var redirectUri: String!

/**
 Optional. A nonce value to be included in the generated ID Token. This is typically provided by the
 application backend, and can be used to ensure at the backend that the authentication
 response corresponds to a specific request issued by the application.
 */
public var nonce: String?

/**
 Optional. A state value to be included in the BindID response issued through redirect. This is
 typically generated at the front-end, and verified at the front-end upon processing the redirect.
 This ensures that the redirect request corresponds to the BindID authentication request.
 */
public var state: String?

/**
 Optional. A set of BindID scopes that will include additional information in the result claims.
 If not provided, only 'Openid' scope is sent
 */
public var scope: [XmBindIdScopeType]?

/**
 A collection of verifications to try and execute for this request. It is not guaranteed that
 each requested verification will be fulfilled. The `acr` claim of the resulting access token
 should be examined to determine which verifications were fulfilled.
 */
public var verifications: [XmRequiredVerifications]?

/**
 Optional. A custom message to present as part of the authentication context detail screen.
 */
public var customMessage: String?

/**
 Indicates if the BindID request will initiate a PKCE flow. In that case, the SDK will generate a code challenge using the S256 hashing algorithm and return the code verifier that can be used for a token exchange. Default is True.
 */
public var usePkce: Bool!

/**
 A flag indicates whether the authentication request should be encrypted.
 */
public var encrypted: Bool?

/**
 Optional. Type and value for the login hint, which is used as a hint for the user’s login identifier (e.g., their email address)
 */
public var loginHint: XmBindIdLoginHint?

/**
 Used to require an authenticating device bound to the Client Application for a specified user (e.g., for step-up authentication). This bound status is reflected in the ID token by the `ts.bindid.app_bound_cred` ACR value, which is set using a session-feedback request.
 */
public var boundTo: XmBindIdBoundTo?
}

/**
 Configuration for a BindID authentication request.
 */
@objc(XmBindIdAuthenticationRequest)
public class XmBindIdAuthenticationRequest : XmBindIdRequest { 

/**
 Creates an instance for an authentication request with the redirect URI and with an option to set encryption.
 */
public convenience init(redirectUri: String, encrypted: Bool) {
     self.init()
     self.redirectUri = redirectUri
     self.encrypted = encrypted
}

/**
 Creates an instance of the authentication request with the redirect URI, without encryption.
 */
public convenience init(redirectUri: String) {
     self.init()
     self.redirectUri = redirectUri
}
}

/**
 (Mobile Only)
 Configuration for a BindID authentication request.
 */
@objc(XmBindIdBoundUserAuthenticationRequest)
public class XmBindIdBoundUserAuthenticationRequest : XmBindIdRequest { 

/**
 Timeout in seconds
 Default is 10.
 */
public var timeout: Int!

/**
 Should display loading indicator
 Default is false.
 */
public var displayLoader: Int!

/**
 Creates an instance for an authentication request with the redirect URI and with an option to set encryption.
 */
public convenience init(redirectUri: String, encrypted: Bool) {
     self.init()
     self.redirectUri = redirectUri
     self.encrypted = encrypted
}

/**
 Creates an instance of the authentication request with the redirect URI, without encryption.
 */
public convenience init(redirectUri: String) {
     self.init()
     self.redirectUri = redirectUri
}
}

/**
 * The data that will be displayed to the user in the transaction consent.
 * NOTE if the below lengths are exceeded, transaction signing will result in failure:
 * payee, paymentMethod are limited to 40 characters each.
 * paymentAmount is limited to 15 characters.
 */
@objc(XmBindIdTransactionSigningDisplayData)
public class XmBindIdTransactionSigningDisplayData : NSObject, Codable { 

public var payee: String!

public var paymentAmount: String!

public var paymentMethod: String!

public init(payee: String, paymentAmount: String, paymentMethod: String) {
     super.init()
     self.payee = payee
     self.paymentAmount = paymentAmount
     self.paymentMethod = paymentMethod
}
}

/**
 * A transaction signing request data object.
 */
@objc(XmBindIdTransactionSigningData)
public class XmBindIdTransactionSigningData : NSObject, Codable { 

/**
 Required. the data that will be displayed to the user in the transaction consent.
 */
public var displayData: XmBindIdTransactionSigningDisplayData!

/**
 Optional. additional data about the transaction, this data will not be displayed to the
 user, however it will be returned as part of the id token claim.
 */
public var additionalData: [String: String]?

/**
 (default is true). Whether this claim is Essential or Voluntary, at the moment
 BindID will always treat this claim as mandatory, this means any problem with obtaining the
 claim (parsing error, user consent etc.) will result in an authentication failure.
 */
public var essential: Bool?

public init(displayData: XmBindIdTransactionSigningDisplayData) {
     super.init()
     self.displayData = displayData
}
}

@objc(XmBindIdTransactionSigningRequest)
public class XmBindIdTransactionSigningRequest : XmBindIdRequest { 

/**
 Required. A transaction signing request data, the data will be sent as a custom OIDC claim under the
 name bindid_psd2_transaction, it will be included in the id_token.
 */
public var transactionSigningData: XmBindIdTransactionSigningData!

/**
 Creates an instance of the transaction signing request with the redirect URI, an option to set encryption, and the transaction signing details.
 */
public convenience init(redirectUri: String, encrypted: Bool, transactionSigningData: XmBindIdTransactionSigningData) {
     self.init()
     self.redirectUri = redirectUri
     self.encrypted = encrypted
     self.transactionSigningData = transactionSigningData
}

/**
 Creates an instance of the transaction signing request with the redirect URI, and transaction signing data. Encrypted will be set to True for this request instance.
 */
public convenience init(redirectUri: String, transactionSigningData: XmBindIdTransactionSigningData) {
     self.init()
     self.redirectUri = redirectUri
     self.transactionSigningData = transactionSigningData
}
}

public enum XmBindIdTokenType : String, CaseIterable, Equatable, Hashable, Codable {
   /** Indicate a Bearer access token.*/ 
   case bearer
} 

/**
 Represents that result of an exchange token request.
 */
public protocol XmBindIdExchangeTokenResponse: Codable { 

/**
 Token-based authentication parameter - Allows an application to access an API.
 The application receives an access token after a user
 successfully authenticates and authorizes access,
 then passes the access token as a credential when it calls the target API.
 */
var accessToken: String! {get}

/**
 Token-based authentication parameter - Used to cache user profile information
 represented in the form of claims.
 */
var idToken: String! {get}

/**
 Type of access token. Currently, only “Bearer” is returned.
 */
var tokenType: XmBindIdTokenType! {get}

/**
 Expiration time of the access token in seconds.
 */
var expiresIn: Int! {get}
}

/**
 Represents that result of an authentication request submitted to BindID.
 */
public protocol XmBindIdResponse: Codable { 

/**
 Authorization code returned by BindID. This can be used to obtain
 the resulting ID Token and Access Token by invoking the
 token endpoint on the BindID OAuth API.
 This value is typically sent to application backend where it is
 exchanged for the sensitive Access Token.
 */
var code: String! {get}

/**
 Optional. The state value returned from the BindID process. This must match the state
 passed in the BindID invocation request, if one was passed.
 */
var state: String? {get}

/**
 Code verifier to use for a PKCE token exchange, provided when the “usePkce” request parameter is set to True.
 */
var codeVerifier: String? {get}

/**
 Redirect URI to use for a PKCE token exchange, which corresponds to the URI passed in the request.
 */
var redirectUri: String! {get}
}

@objc(XmBindIdExchangeTokenRequest)
public class XmBindIdExchangeTokenRequest : NSObject, Codable { 

public internal (set) var codeVerifier: String?

public internal (set) var code: String!

public internal (set) var redirectUri: String!

/**
 Creates an instance of the exchange token request with the response of the authenticate() or signTransaction() call (if the “usePkce” request parameter was set to True). The response includes the code verifier, authorization code, and redirect URI required for the token exchange.
 */
public init(codeResponse: XmBindIdResponse) {
     super.init()
     self.codeResponse = codeResponse
}
}

/**
 Entry point interface to the BindID Client SDK.
 
 This interface declares all top level services supported by the SDK. An instance of this interface is available
 to client applications as window.XmBindId.
 
 Before the BindID SDK can be used, the {@link XmBindIdSdk.initialize} call must be invoked, with proper configuration for the client
 application using BindID.
 */
@objc(XmBindIdSdk)
public class XmBindIdSdk : NSObject, Codable { 

private override init() { super.init() }

public static let shared: XmBindIdSdk = XmBindIdSdk()

/**
 Initialize the BindID Client SDK and set application-wide configuration.
 
 All BindID Client SDK calls must be invoked only after succesful completion of this asynchornous
 initialization call.
 
 The returned promise will either be resolved with a boolean 'true' value, or rejected with an error.
 
 @param config Application-wide BindID Client SDK configuration.
 * @param handler 
 */
public func initialize(config: XmBindIdConfig, completion: ((Bool?, XmBindIdError?) -> ())?) {
  return XmBindIdSdkImpl.shared.initialize(config: config, completion: completion) 
}

/**
 Invoke a BindID authentication flow.
 
 This call will start a user login flow using BindID. The browser will be redirected to BindID's
 login page, where user identity will be established. Once complete, BindID will redirect the user
 back to the invoking web/mobile application based on the URL provided in the authentication request parameters,
 sending back authentication result information.
 
 If invoked by a web application, the web application should invoke
 #processRedirectResponse to extract the information returned in the response and complete the authentication
 process.
 
 The returned Promise will either be rejected with an error, or never complete (since this call may redirect
 the user agent to another page).
 
 @param bindIdRequestParams Authentication request parameters.
 * @param handler 
 */
public func authenticate(bindIdRequestParams: XmBindIdAuthenticationRequest, completion: ((XmBindIdResponse?, XmBindIdError?) -> ())?) {
  return XmBindIdSdkImpl.shared.authenticate(bindIdRequestParams: bindIdRequestParams, completion: completion) 
}

public func authenticateBoundUser(bindIdRequestParams: XmBindIdBoundUserAuthenticationRequest, completion: ((XmBindIdResponse?, XmBindIdError?) -> ())?) {
  return XmBindIdSdkImpl.shared.authenticateBoundUser(bindIdRequestParams: bindIdRequestParams, completion: completion) 
}

/**
 
 Invoke BindID authentication flow for transaction signing.
 
 This request will behave similarly to an authentication request, with the following additions:
 
 OIDC claims parameter will be added to the request to indicate the BindID server that this is a transaction
 signing request.
 By default the request will be sent as an encrypted JWT.
 BindID server will show the transaction details to the user.
 BindID server will include the transaction claim in the id_token upon successful authentication and token exchange.
 
 @param bindIdTransactionRequest Transaction request object
 * @param handler 
 */
public func signTransaction(bindIdTransactionRequest: XmBindIdTransactionSigningRequest, completion: ((XmBindIdResponse?, XmBindIdError?) -> ())?) {
  return XmBindIdSdkImpl.shared.signTransaction(bindIdTransactionRequest: bindIdTransactionRequest, completion: completion) 
}

/**
 Invoke a PKCE token exchange using the BindID SDK. The response will include the ID and access tokens.
 * @param handler 
 */
public func exchangeToken(exchangeRequest: XmBindIdExchangeTokenRequest, completion: ((XmBindIdExchangeTokenResponse?, XmBindIdError?) -> ())?) {
  return XmBindIdSdkImpl.shared.exchangeToken(exchangeRequest: exchangeRequest, completion: completion) 
}
}

