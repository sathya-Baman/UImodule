//
//  PrivacyScreenManager.swift
//
//
//  Created by baman on R 7/12/24.
//

import UIKit

@available(iOS 13.0, *)
public final class PrivacyScreenManager {

    // MARK: - Singleton
    public static let shared = PrivacyScreenManager()
    private init() {}

    // MARK: - Properties
    private var isFeatureEnabled = false
    private var pirateImage: UIImage?

    private lazy var privacyProtectionView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 999   // identify later

        view.contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        return view
    }()

    // MARK: - Public API
    public func enableFeature() {
        guard !isFeatureEnabled else { return }
        isFeatureEnabled = true
        // Image lives in the pod/framework resource bundle — load it from this class's bundle
        pirateImage = loadImage(named: "pirate_image")

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    // MARK: - Image Loading Helper
    private func loadImage(named name: String) -> UIImage? {
        // 1) Try the framework/pod bundle where this class is defined
        let classBundle = Bundle(for: PrivacyScreenManager.self)
        if let img = UIImage(named: name, in: classBundle, compatibleWith: nil) {
            return img
        }

        // 2) Try the main bundle (app targets sometimes put assets there)
        if let img = UIImage(named: name) {
            return img
        }

        // 3) Try direct file lookup in the class bundle for common extensions
        let candidates = ["png", "jpg", "jpeg"]
        for ext in candidates {
            if let path = classBundle.path(forResource: name, ofType: ext),
               let img = UIImage(contentsOfFile: path) {
                return img
            }
        }

        // 4) As a last resort, try main bundle file lookup
        for ext in candidates {
            if let path = Bundle.main.path(forResource: name, ofType: ext),
               let img = UIImage(contentsOfFile: path) {
                return img
            }
        }

        return nil
    }

    // MARK: - Background / Foreground
    @objc private func appDidEnterBackground() {
        guard isFeatureEnabled,
              let window = keyWindow()
        else { return }

        if privacyProtectionView.superview == nil {
            if let imageView = privacyProtectionView.contentView.viewWithTag(999) as? UIImageView {
                imageView.image = pirateImage
            }

            window.addSubview(privacyProtectionView)

            NSLayoutConstraint.activate([
                privacyProtectionView.topAnchor.constraint(equalTo: window.topAnchor),
                privacyProtectionView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                privacyProtectionView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                privacyProtectionView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        }
    }

    @objc private func appWillEnterForeground() {
        privacyProtectionView.removeFromSuperview()
    }

    // MARK: - Window Resolver (Scene-safe)
    private func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
