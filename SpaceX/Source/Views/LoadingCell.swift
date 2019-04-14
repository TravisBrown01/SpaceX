
import Foundation
import UIKit

class LoadingCell: UITableViewCell {
    let spinner = UIActivityIndicatorView(style: .gray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(spinner)
        spinner.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.contentView)
        }
        spinner.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
