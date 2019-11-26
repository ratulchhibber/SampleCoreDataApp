import Foundation
import UIKit

class ActivityIndicator {
    
    static let shared = ActivityIndicator()
    var container = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    private init() { }
    
    func show(in view: UIView) {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = .clear
    
        loadingView.frame = CGRect(origin: .zero,
                                   size: CGSize(width: 80, height: 80))
        loadingView.center = view.center
        loadingView.backgroundColor = .clear
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
    
        activityIndicator.frame = CGRect(origin: .zero,
                                         size: CGSize(width: 40, height: 40))
        activityIndicator.style = .large
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }

    func hide() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
