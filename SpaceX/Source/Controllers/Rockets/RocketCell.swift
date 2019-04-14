
import Foundation
import UIKit

class RocketCell: UITableViewCell {
    
    private let logoImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([logoImageView, nameLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.size = CGSize(width: 40, height: 40)
        logoImageView.left = 16
        
        nameLabel.sizeToFit()
        nameLabel.left = logoImageView.right + 10
        nameLabel.centerY = contentView.boundsCenterY
    }
    
    func configure(with rocket: Rocket) {
        configure(with: rocket.name, rocketType: rocket.type)
    }
    
    func configure(with rocketName: String, rocketType: Rocket.RocketType) {
        nameLabel.text = rocketName
        
        switch rocketType {
        case .falcon1: logoImageView.image = #imageLiteral(resourceName: "Falcon")
        case .falcon9: logoImageView.image = #imageLiteral(resourceName: "Falcon9")
        case .falconHeavy: logoImageView.image = #imageLiteral(resourceName: "FalconHeavy")
        default: logoImageView.image = #imageLiteral(resourceName: "spacex")
        }
        
        setNeedsLayout()
    }
    
}
