
import UIKit

class LaunchesView: UIView {
    
    let tableView = UITableView(frame: .zero).setUp {
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
    }
    
    let refreshControl = UIRefreshControl().setUp {
        $0.tintColor = .white
    }
    
    let segmentedControl = UISegmentedControl(items: ["History", "Upcoming"]).setUp {
        $0.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        tableView.refreshControl = refreshControl
        
        addSubviews([segmentedControl, tableView])
        
        backgroundColor = .black
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        
        segmentedControl.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.width.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.updateConstraints { (make) in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
