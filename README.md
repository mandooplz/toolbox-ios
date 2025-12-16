- [개요](#개요)
- [인증](#인증)
  - [KakaoLoginManager](#kakaologinmanager)
    - [준비](#준비)
    - [예시](#예시)

## 개요

iOS App 개발에 사용할 수 있는 유틸리티 라이브러리입니다.

## 인증

### KakaoLoginManager

#### 준비

- [Kakao Login for iOS](https://developers.kakao.com/docs/latest/ko/kakaologin/ios)
- [앱 실행 허용 목록에 카카오톡 추가](https://developers.kakao.com/docs/latest/ko/ios/getting-started#project-plist)
- [커스텀 URL Scheme 추가](https://developers.kakao.com/docs/latest/ko/ios/getting-started#project-schemes)
- [발급받은 AppKey로 SDK 초기화](https://developers.kakao.com/docs/latest/ko/ios/getting-started#init)
- [애플리케이션에 카카오톡 Service 통합](https://developers.kakao.com/docs/latest/ko/kakaologin/ios#before-you-begin-setting-for-kakaotalk)
- [동의항목 추가 동의 요청](https://developers.kakao.com/docs/latest/ko/kakaologin/ios#request-code-additional-consent)

#### 예시

```swift

let loginManager = KakaoLoginManager(appKey: "YOUT_NATIVE_APP_KEY")

loginManager.setUp()

await loginManager.loginWithKakaoApp()
await loginManager.loginWithWebBrowser()

```
