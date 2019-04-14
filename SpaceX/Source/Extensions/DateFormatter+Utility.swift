
import Foundation

extension DateFormatter {
    static var ISO8601: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    static let launchDateFormatter = DateFormatter().setUp {
        $0.dateStyle = .medium
        $0.timeStyle = .short
    }
    
    static let launchDateNETDayFormatter = DateFormatter().setUp {
        $0.dateStyle = .medium
    }
    
    static let launchDateNETMonthFormatter = DateFormatter().setUp {
        $0.setLocalizedDateFormatFromTemplate("MMM yyyy")
    }
    
    static let launchDateNETQuarterFormatter = DateFormatter().setUp {
        $0.setLocalizedDateFormatFromTemplate("QQQ yyyy")
    }
    
    static let launchDateNETYearFormatter = DateFormatter().setUp {
        $0.setLocalizedDateFormatFromTemplate("yyyy")
    }
}
