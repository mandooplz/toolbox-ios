//
//  KakaoLoginManager.swift
//  ToolBoxiOS
//
//  Created by 김민우 on 12/16/25.
//
import Foundation
import KakaoSDKCommon
import KakaoSDKUser
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
    
    public var authToken: String? = nil
    
    
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
        
        // process
        
        // mutate
        
        fatalError("구현 예정입니다.")
    }
    public func loginWithWebBrowser() async {
        // capture
        
        // process
        
        // mutate
        
        fatalError("구현 예정입니다.")
    }
}
