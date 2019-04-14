
import Foundation
import RxSwift

class RoadsterViewModel: ValueViewModel<Roadster> {
    
    private let template = "The Tesla Roadster with Starman are now at a distance of <highlight>{earth_distance} km</highlight> from our Planet\n\n The Movement speed is <highlight>{speed} km/h</highlight>\n\n The Tesla Roadster flies around the Sun every <highlight>{period} day</highlight>\n\nThe weight is <highlight>{weight} kg</highlight> and the total number of days in space <highlight>{duration}</highlight>"
    
    private let noDecimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 0
    }
    
    private let decimalsNumberFormatter = NumberFormatter().setUp {
        $0.numberStyle = .decimal
        $0.maximumFractionDigits = 2
    }
    
    let roadsterDescription = Variable<String?>(nil)
    
    init(api: API) {
        super.init(api: api, target: .roadster)
        
        object.asObservable().unwrap().map { [weak self] roadster -> String? in
            guard let s = self else { return nil }
            
            return s.template
                .replacingOccurrences(of: "{earth_distance}", with: s.noDecimalsNumberFormatter.string(from: roadster.earthDistanceKm as NSNumber)!)
                .replacingOccurrences(of: "{speed}", with: s.noDecimalsNumberFormatter.string(from: roadster.speed.kmh as NSNumber)!)
                .replacingOccurrences(of: "{period}", with: s.noDecimalsNumberFormatter.string(from: roadster.periodDays as NSNumber)!)
                .replacingOccurrences(of: "{periapsis}", with: s.decimalsNumberFormatter.string(from: roadster.periapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{apoapsis}", with: s.decimalsNumberFormatter.string(from: roadster.apoapsisAu as NSNumber)!)
                .replacingOccurrences(of: "{weight}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchMass.kilos as NSNumber)!)
                .replacingOccurrences(of: "{duration}", with: s.noDecimalsNumberFormatter.string(from: roadster.launchDate.daysAgo as NSNumber)!)
            
        }.bind(to: roadsterDescription).disposed(by: bag)
    }
}
