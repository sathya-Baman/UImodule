//
//  PrivacyScreenManager.swift
//  
//
//  Created by baman on R 7/12/24.
//

import UIKit

public class PrivacyScreenManager {
    
    // MARK: - Singleton
    
    // Use a singleton pattern to easily access the manager
    public static let shared = PrivacyScreenManager()
    private init() {
        // Private initializer to enforce singleton usage
    }
    
    // MARK: - Private Properties
    
    private var isFeatureEnabled: Bool = false
    
    // The view that will contain the blur effect and the pirate image
    private lazy var privacyProtectionView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup the image view
        let imageView = UIImageView(image: UIImage(named: "pirate_image"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add image to the view's content view
        view.contentView.addSubview(imageView)
        
        // Center the image within the blur view
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        return view
    }()
    
    // MARK: - Public API
    
    /**
     Enables the privacy screen feature and starts observing app lifecycle events.
     
     - Parameter image: The `UIImage` for the pirate logo. This must be passed from the main app.
     */
    public func enableFeature(withPirateImage image: UIImage) {
        guard !isFeatureEnabled else { return }
        isFeatureEnabled = true
        
        // Set the pirate image in the view (assuming you have access to the image view)
        // A cleaner way is to pass the image from the main app.
        // For simplicity, we assume 'pirate_image' is accessible or handle it here:
        if let imageView = privacyProtectionView.contentView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            imageView.image = image
        }
        
        // Register for notifications when the app enters background/foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    // MARK: - Lifecycle Handlers
    
    @objc private func appWillResignActive() {
        guard isFeatureEnabled else { return }
        
        // This is called just before the app goes to the background (when the home button is pressed)
        // and when control center/notification shade is pulled down.
        
        // 1. Get the key window
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // 2. Add the blur view on top of everything
        window.addSubview(privacyProtectionView)
        
        // 3. Constrain it to fill the entire window
        NSLayoutConstraint.activate([
            privacyProtectionView.topAnchor.constraint(equalTo: window.topAnchor),
            privacyProtectionView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            privacyProtectionView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            privacyProtectionView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }
    
    @objc private func appDidBecomeActive() {
        guard isFeatureEnabled else { return }
        
        // This is called when the app returns to the foreground
        
        // Remove the blur view from the hierarchy
        privacyProtectionView.removeFromSuperview()
    }
    
    // MARK: - Deinitialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
