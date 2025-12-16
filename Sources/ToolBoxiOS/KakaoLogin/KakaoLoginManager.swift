//
//  KakaoLoginManager.swift
//  ToolBoxiOS
//
//  Created by 김민우 on 12/16/25.
//
import Foundation
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import OSLog


// MARK: Object
@MainActor @Observable
public final class KakaoLoginManager: Sendable {
    // MARK: core
    private nonisolated let logger = Logger()
    public init(appKey: String) {
        self.appKey = appKey
    }
    
    
    // MARK: state
    private let appKey: String
    private var isSetUp: Bool = false
    
    public private(set) var authToken: AuthToken? = nil
    public func removeAuthToken() {
        self.authToken = nil
    }
    
    public func logout() async {
        guard isSetUp == true else {
            logger.error("SetUp이 되어 있지 않습니다. KakaoLoginManager.setUp() 호출이 필요합니다.")
            return
        }
        
        await withCheckedContinuation { continuation in
            UserApi.shared.logout { [weak self] error in
                if let error {
                    self?.logger.error("\(error)")
                }
                
                self?.authToken = nil
                continuation.resume()
            }
        }
    }
    
    
    // MARK: action
    public func setUp() {
        // capture
        let appKey = self.appKey
        
        // process
        KakaoSDK.initSDK(appKey: appKey)
        
        // mutate
        self.isSetUp = true
    }
    
    public func loginWithKakaoApp() async {
        // capture
        guard isSetUp == true else {
            logger.error("SetUp이 되어 있지 않습니다. KakaoLoginManager.setUp() 호출이 필요합니다.")
            return
        }
        guard self.authToken == nil else {
            logger.error("이미 로그인된 상태입니다. KakaoLoginManager.logout() 또는 KakaoLoginManager.removeAuthToken() 호출 후 시도해주세요.")
            return
        }
        
        // process
        let authToken: AuthToken? = await withCheckedContinuation { continuation in
            guard UserApi.isKakaoTalkLoginAvailable() == true else {
                continuation.resume(returning: nil)
                return
            }
            
            UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
                guard error == nil else {
                    self?.logger.error("\(error!)")
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let oauthToken else {
                    self?.logger.error("KakaoTalk 로그인은 성공했으나, oauthToken이 없습니다. (정상적인 상황은 아닙니다.)")
                    continuation.resume(returning: nil)
                    return
                }
                
                // 성공 시 동작 구현
                let authToken = AuthToken(oauthToken)
                
                continuation.resume(returning: authToken)
                self?.logger.debug("KakaoTalk 로그인 성공")
            }
        }
        
        // mutate
        self.authToken = authToken
    }
    public func loginWithWebBrowser() async {
        // capture
        guard isSetUp == true else {
            logger.error("SetUp이 되어 있지 않습니다. KakaoLoginManager.setUp() 호출이 필요합니다.")
            return
        }
        guard self.authToken == nil else {
            logger.error("이미 로그인된 상태입니다. KakaoLoginManager.logout() 또는 KakaoLoginManager.removeAuthToken() 호출 후 시도해주세요.")
            return
        }
        
        
        // process
        let authToken: AuthToken? = await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount {[weak self] (oauthToken, error) in
                guard error == nil else {
                    self?.logger.error("\(error)")
                    continuation.resume(returning: nil)
                    return
                }
                
                guard let oauthToken else {
                    self?.logger.error("웹브라우저로 카카오 로그인은 성공했으나, oauthToken이 없습니다. (정상적인 상황은 아닙니다.)")
                    continuation.resume(returning: nil)
                    return
                }
                
                let authToken = AuthToken(oauthToken)
                continuation.resume(returning: authToken)
                
                self?.logger.debug("웹브라우저를 통해 카카오 로그인을 성공했습니다.")
            }
        }
        
        
        // mutate
        self.authToken = authToken
    }
    
    
    // MARK: value
    public struct AuthToken: Sendable, Hashable {
        // MARK: core
        public let idToken: String?
        
        public let accessToken: String
        public let expiredAt: Date
        
        public let refreshToken: String
        public let refreshTokenExpiredAt: Date
        
        public let scopes: [String]?
        
        fileprivate init(_ token: OAuthToken) {
            self.idToken = token.idToken
            self.accessToken = token.accessToken
            self.expiredAt = token.expiredAt
            self.refreshToken = token.refreshToken
            self.refreshTokenExpiredAt = token.refreshTokenExpiredAt
            self.scopes = token.scopes
        }
    }
}
