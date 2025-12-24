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
    public func enableFeature(withPirateImage image: UIImage) {
        guard !isFeatureEnabled else { return }
        isFeatureEnabled = true
        pirateImage = image

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
