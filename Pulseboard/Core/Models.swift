import Foundation

// MARK: - Models

/// Represents a snapshot of the operational reality at a specific moment.
struct OpsSignal: Equatable {
    let activeOrders: Int
    let avgWaitTime: Int
    let fulfillmentRate: Double
    let surgeActive: Bool
    
    // Default / Empty State
    static let initial = OpsSignal(
        activeOrders: 450,
        avgWaitTime: 12,
        fulfillmentRate: 98.5,
        surgeActive: false
    )
}

/// The derived state that dictates the UI layout.
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
