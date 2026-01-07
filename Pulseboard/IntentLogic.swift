import SwiftUI
import Combine

enum IntentMode: String, CaseIterable, Identifiable {
    case peak
    case lowActivity
    case surge
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .peak: return "Peak Hours"
        case .lowActivity: return "Low Activity"
        case .surge: return "Surge Mode"
        }
    }
}

class DashboardState: ObservableObject {
    @Published var activeMode: IntentMode = .peak
}
