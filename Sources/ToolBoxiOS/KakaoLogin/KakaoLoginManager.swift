//
//  KakaoLoginManager.swift
//  ToolBoxiOS
//
//  Created by 김민우 on 12/16/25.
//
import Foundation
import KakaoSDKCommon


// MARK: Object
@MainActor @Observable
public final class KakaoLoginManager: Sendable {
    // MARK: core
    public init(appKey: String) {
        self.appKey = appKey
    }
    
    
    // MARK: state
    private var isSetUp: Bool = false
    private let appKey: String
    
    
    // MARK: action
    public func setUp() {
        // capture
        let appKey = self.appKey
        
        // process
        KakaoSDK.initSDK(appKey: appKey)
        
        // mutate
        self.isSetUp = true
    }
    public func login() async {
        
    }
}
