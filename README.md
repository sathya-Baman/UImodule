# UImodule
This module implements a privacy screen mechanism that automatically protects sensitive content when the application is no longer in active use.
When the app moves to the background—for example, when the user switches to another app, opens the app switcher, or locks the device—the module immediately displays a secure overlay that hides all visible content within the app. This prevents any on-screen information from being exposed in system previews, screenshots, or accidental viewing.
By temporarily obscuring the app’s UI while it is inactive, the module ensures that confidential or sensitive data remains protected, even if the app is backgrounded unintentionally. Once the user returns to the app, the privacy screen is removed and normal interaction resumes.
This behavior is fully handled within the module itself, requiring minimal configuration from the host application while significantly improving user privacy and data security.

[![CI Status](https://img.shields.io/travis/sathya-Baman/UImodule.svg?style=flat)](https://travis-ci.org/sathya-Baman/UImodule)
[![Version](https://img.shields.io/cocoapods/v/UImodule.svg?style=flat)](https://cocoapods.org/pods/UImodule)
[![License](https://img.shields.io/cocoapods/l/UImodule.svg?style=flat)](https://cocoapods.org/pods/UImodule)
[![Platform](https://img.shields.io/cocoapods/p/UImodule.svg?style=flat)](https://cocoapods.org/pods/UImodule)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

UImodule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UImodule'
```

## How to implement

Implementing this feature is very straightforward and requires minimal effort from the host application.
To enable the privacy screen functionality, simply turn it on when the app starts. This is typically done in the application(_:didFinishLaunchingWithOptions:) method. Once enabled at launch, the module automatically handles all required logic, including monitoring the app’s lifecycle and displaying or hiding the privacy screen as needed.

No additional setup or ongoing management is required. After initialization, the feature runs seamlessly in the background, ensuring that sensitive content is protected whenever the app becomes inactive.

```Swift
func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
) -> Bool {
   PrivacyScreenManager.shared.enableFeature()
   return true
}
```

## Demo screen 
<img width="315" height="692" alt="Screenshot 0007-12-26 at 14 29 02" src="https://github.com/user-attachments/assets/ae297998-a9a3-4159-b534-bdd1bf4dca7f" />


## Author

sathya-Baman, sathyabaman.kanasalingam@e-jan.co.jp

## License

UImodule is available under the MIT license. See the LICENSE file for more info.

