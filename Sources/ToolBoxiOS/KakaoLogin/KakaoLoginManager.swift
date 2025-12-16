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
    
    public private(set) var authToken: String? = nil
    public func removeAuthToken() {
        self.authToken = nil
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
            logger.error("이미 로그인된 상태입니다. KakaoLoginManager.logout() 호출 후 시도해주세요.")
            return
        }
        
        // process
        let oauthToken: AuthToken? = await withCheckedContinuation { continuation in
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
        self.authToken = oauthToken?.accessToken
    }
    public func loginWithWebBrowser() async {
        // capture
        guard isSetUp == true else {
            logger.error("SetUp이 되어 있지 않습니다. KakaoLoginManager.setUp() 호출이 필요합니다.")
            return
        }
        guard self.authToken == nil else {
            logger.error("이미 로그인된 상태입니다. KakaoLoginManager.logout() 호출 후 시도해주세요.")
            return
        }
        
        // process
        
        
        // mutate
        
        fatalError("구현 예정입니다.")
    }
    
    
    // MARK: value
    /// 토큰별 역할과 만료 시간 (Kakao OAuth)
    ///
    /// - Access Token
    ///   - 역할: API 요청 시 사용자 인증 및 권한 보유 증명에 사용
    ///   - 만료 시간:
    ///     - Android / iOS: 12시간
    ///     - JavaScript: 2시간
    ///     - REST API: 6시간
    ///
    /// - Refresh Token
    ///   - 역할: 추가 인증 없이 Access Token 갱신
    ///   - 만료 시간: 2달
    ///   - 만료 1달 전부터 갱신 가능
    ///   - 중요: 토큰 갱신 요청 시
    ///           새로운 Refresh Token이 발급되며
    ///           기존 Refresh Token은 폐기됨
    ///
    /// - ID Token
    ///   - 역할: 로그인 세션에서 사용 가능한 사용자 인증 정보 제공
    ///   - 비고: OpenID Connect 활성화 필요
    ///   - 만료 시간: Access Token과 동일
    public struct AuthToken: Sendable, Hashable {
        // MARK: core
        let idToken: String?
        
        let accessToken: String
        let expiredAt: Date
        
        let refreshToken: String
        let refreshTokenExpiredAt: Date
        
        let scopes: [String]?
        
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
