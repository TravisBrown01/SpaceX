import RxCocoa
import RxSwift
import SwiftRichString
import UIKit

class RoadsterViewController: UIViewController {

    // MARK: - Variables

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    private let _view = RoadsterView()
    private let viewModel: RoadsterViewModel
    private let bag = DisposeBag()
    
    private let normalStyle = SwiftRichString.Style {
        $0.font = UIFont.italicSystemFont(ofSize: 18)
        $0.paragraph = NSMutableParagraphStyle().setUp {
            $0.minimumLineHeight = 30
            $0.alignment = .center
        }
        $0.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private let highlihgtStyle = SwiftRichString.Style {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.traitVariants = .italic
    }
    
    private lazy var group = StyleGroup(base: normalStyle, ["highlight": highlihgtStyle])

    // MARK: - Inits

    init(viewModel: RoadsterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func loadView() {
        view = _view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-close"), style: .plain, target: nil, action: nil)
        close.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        navigationItem.leftBarButtonItem = close
        
        let share = UIBarButtonItem(image: #imageLiteral(resourceName: "screenshot"), style: .plain, target: nil, action: nil)
        share.rx.tap.bind {
            print("HELLO")
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            let stitchedImages = self.view.capture()
            
            UIGraphicsEndImageContext()
            
            var imagesToShare = [AnyObject]()
            imagesToShare.append(stitchedImages!)
            
            let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        navigationItem.rightBarButtonItem = share
        
        viewModel.loadAction.executing.bind(to: _view.spinner.rx.isAnimating).disposed(by: bag)
        
        viewModel.roadsterDescription.asObservable().unwrap().subscribe(onNext: { [weak self] (description) in
            self?.updateView(with: description)
        }).disposed(by: bag)
        
        viewModel.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Style.appearance.applyTranslucentNavigationBarAppearance(to: navigationController?.navigationBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Analytics.trackRoadsterShown()
    }
    
    private func updateView(with text: String) {
        _view.textLabel.attributedText = text.set(style: group)
    }

    deinit {
        print("Deinit \(type(of: self))")
    }
}

extension UIView {
    
    func capture() -> UIImage? {
        var image: UIImage?
        
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
            image = renderer.image { context in
                drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
            drawHierarchy(in: frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.init(red:221/255.0, green:221/255.0, blue:221/255.0, alpha: 1.0).cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = .zero
        layer.shadowRadius = 20
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 1, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
