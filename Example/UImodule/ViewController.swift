//
//  ViewController.swift
//  UImodule
//
//  Created by sathya-Baman on 12/24/2025.
//  Copyright (c) 2025 sathya-Baman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text =
        """
        Push the app to the background and open another app.
        Then return to the background to see how this feature works.
        """
        textView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textView.textColor = .darkGray
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)

        view.addSubview(containerView)
        containerView.addSubview(messageTextView)

        NSLayoutConstraint.activate([
            // Container centered
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // TextView inside container
            messageTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            messageTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            messageTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}
