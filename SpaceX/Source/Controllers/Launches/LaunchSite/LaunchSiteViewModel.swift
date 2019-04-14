
import Foundation
import RxSwift
import MapKit

class LaunchSiteViewModel: ValueViewModel<LaunchSite> {
    
    let location = Variable<CLLocation?>(nil)
    
    init(launchSiteId: String) {
        super.init(api: SpaceXAPI, target: .launchSite(id: launchSiteId))
        
        object.asObservable().unwrap().map { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude) }.bind(to: location).disposed(by: bag)
    }
    
}
