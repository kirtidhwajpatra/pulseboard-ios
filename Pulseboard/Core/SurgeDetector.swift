import Foundation

struct SurgeDetector {
    /// Pure logic to determine if we are in a Surge state based on operational patterns.
    static func evaluate(current: OpsSignal, previous: OpsSignal) -> Bool {
        var riskScore = 0
        
        // 1. Rising Orders Trend
        if current.activeOrders > previous.activeOrders {
            riskScore += 1
        }
        
        // 2. Critical Wait Times
        if current.avgWaitTime >= 15 {
            riskScore += 1
        }
        
        // 3. Degrading Fulfillment
        if current.fulfillmentRate < 96.0 {
            riskScore += 1
        }
        
        // 4. High Volume Absolute
        if current.activeOrders > 1000 {
            riskScore += 1
        }
        
        let shouldSurge = riskScore >= 2
        
        // Hysteresis / Stability Check
        // If we are ALREADY surging, we need strictly better conditions to stop.
        if previous.surgeActive {
            // Only resolve if things strictly improve
            let safeToResolve = current.avgWaitTime < 12 &&
                                current.fulfillmentRate >= 97.0 &&
                                current.activeOrders <= previous.activeOrders
            
            return !safeToResolve // Stay surging unless safe
        } else {
            return shouldSurge
        }
    }
}
