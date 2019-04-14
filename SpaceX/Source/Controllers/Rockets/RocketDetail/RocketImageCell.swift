
import Foundation
import UIKit

class RocketImageCell: UITableViewCell {
    let rocketImageView = UIImageView().setUp {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([rocketImageView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rocketImageView.width = contentView.width
        rocketImageView.height = contentView.height - 20
        rocketImageView.centerX = contentView.boundsCenterX
        rocketImageView.centerY = contentView.boundsCenterY
    }
}
