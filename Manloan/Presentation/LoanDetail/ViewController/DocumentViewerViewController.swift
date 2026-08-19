//
//  DocumentViewerViewController.swift
//  Manloan
//
//  Created by Muhammad Hamzah Robbani on 19/08/26.
//

import UIKit
import Kingfisher

final class DocumentViewerViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.minimumZoomScale = 1.0
        sv.maximumZoomScale = 3.0
        sv.backgroundColor = .clear
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.alwaysBounceVertical = true
        sv.bounces = true
        return sv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.color = .white
        return ai
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Failed to load document"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    private var panGesture: UIPanGestureRecognizer!
    private var originalCenter: CGPoint = .zero
    private var isDismissing = false
    private var backgroundView: UIView!
    
    private let document: Document
    private let imageUrl: URL
    
    init(document: Document) {
        self.document = document
        self.imageUrl = DocumentViewerViewController.buildFullURL(for: document.url)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSwipeToDismiss()
        loadImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        
        view.addSubview(loadingIndicator)
        
        view.addSubview(errorLabel)
        view.addSubview(retryButton)
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupSwipeToDismiss() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .began:
            originalCenter = scrollView.center
            isDismissing = false
            
        case .changed:
            guard scrollView.zoomScale <= 1.0 else { return }
            
            let progress = translation.y / view.bounds.height
            let newY = originalCenter.y + translation.y
            
            scrollView.center = CGPoint(x: originalCenter.x, y: newY)
            
            let alpha = max(0.2, 1.0 - abs(progress) * 0.8)
            backgroundView.backgroundColor = .black.withAlphaComponent(alpha)
            
            let scale = 1.0 - min(abs(progress) * 0.3, 0.3)
            scrollView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            closeButton.alpha = 1.0 - abs(progress) * 1.5
            
        case .ended, .cancelled:
            let progress = translation.y / view.bounds.height
            let shouldDismiss = progress > 0.2 || velocity.y > 500
            
            if shouldDismiss {
                dismissWithAnimation()
            } else {
                resetWithAnimation()
            }
            
        default:
            break
        }
    }
    
    private func dismissWithAnimation() {
        isDismissing = true
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.scrollView.center = CGPoint(
                    x: self.originalCenter.x,
                    y: self.view.bounds.height * 1.5
                )
                self.backgroundView.backgroundColor = .black.withAlphaComponent(0)
                self.scrollView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.closeButton.alpha = 0
            },
            completion: { _ in
                self.dismiss(animated: false)
            }
        )
    }
    
    private func resetWithAnimation() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.scrollView.center = self.originalCenter
                self.backgroundView.backgroundColor = .black
                self.scrollView.transform = .identity
                self.closeButton.alpha = 1
            }
        )
    }

    private func loadImage() {
        loadingIndicator.startAnimating()
        errorLabel.isHidden = true
        retryButton.isHidden = true
        
        KingfisherManager.shared.retrieveImage(
            with: imageUrl,
            options: [
                .backgroundDecode,
                .forceRefresh,
                .alsoPrefetchToMemory
            ]
        ) { [weak self] result in
            self?.loadingIndicator.stopAnimating()
            
            switch result {
            case .success(let value):
                self?.imageView.image = value.image
                
                DispatchQueue.main.async {
                    self?.imageView.setNeedsDisplay()
                }
                
            case .failure(let error):
                self?.showError(error: error)
            }
        }
    }
    
    private func showError(error: KingfisherError) {
        errorLabel.isHidden = false
        retryButton.isHidden = false
        print("❌ Failed to load image: \(error.localizedDescription)")
    }
    
    @objc private func handleRetry() {
        loadImage()
    }
    
    @objc private func handleClose() {
        dismiss(animated: true)
    }
    
    static func buildFullURL(for path: String) -> URL {
        let baseURL = "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main"
        let fullPath = baseURL + path
        return URL(string: fullPath)!
    }
}

extension DocumentViewerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        imageView.frame.origin = CGPoint(x: offsetX, y: offsetY)
    }
}

extension DocumentViewerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
