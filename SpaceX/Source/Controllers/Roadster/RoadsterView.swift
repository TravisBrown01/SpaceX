
import UIKit

class RoadsterView: UIView {
    
    private let roadsterImageView = UIImageView(image: #imageLiteral(resourceName: "roadster")).setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    let textLabel = UILabel().setUp {
        $0.numberOfLines = 0
    }
    
    private let updatedLabel = UILabel().setUp {
        $0.font = UIFont.italicSystemFont(ofSize: 14)
        $0.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        $0.textAlignment = .center
        $0.text = "We are updating the information every 10 minutes"
        $0.alpha = 0.5
    }
    
    let spinner = UIActivityIndicatorView().setUp {
        $0.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        
        self.layer.addSublayer(gradientLayer)
        
        addSubviews([roadsterImageView, textLabel, updatedLabel, spinner])
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override func updateConstraints() {
        
        roadsterImageView.snp.updateConstraints { (make) in
            make.top.greaterThanOrEqualTo(safeAreaLayoutGuide)
            make.top.lessThanOrEqualTo(safeAreaLayoutGuide).offset(40)
            make.width.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(roadsterImageView.snp.width)
        }
        
        textLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.lessThanOrEqualTo(roadsterImageView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-60)
            make.bottom.equalTo(updatedLabel.snp.top).offset(-20)
        }
        
        updatedLabel.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        spinner.snp.updateConstraints { (make) in
            make.center.equalTo(textLabel)
        }
        
        super.updateConstraints()
    }
}
