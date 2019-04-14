
import Foundation
import RxSwift

class RocketsViewModel: ValuesViewModel<Rocket> {
    
    init(api: API) {
        super.init(api: api, target: .rockets)
    }
    
}
