import Foundation
import Combine

class SignalSimulator {
    // Publisher that ViewModel subscribes to
    let signalPublisher = PassthroughSubject<OpsSignal, Never>()
    
    private var timer: Timer?
    private var currentSignal: OpsSignal
    
    // Target state we are drifting towards
    private enum SimulationTarget {
        case normal
        case surge
    }
    private var target: SimulationTarget = .normal
    
    init(initialSignal: OpsSignal = .initial) {
        self.currentSignal = initialSignal
    }
    
    // MARK: - Controls
    
    func start() {
        stop() // Safety check
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func triggerSurge() {
        target = .surge
    }
    
    func resolveSurge() {
        target = .normal
    }
    
    // MARK: - Simulation Loop
    
    private func tick() {
        var next = currentSignal
        
        switch target {
        case .normal:
            // Drift towards Normal Baseline
            // Orders: Target ~450
            next = OpsSignal(
                activeOrders: drift(current: next.activeOrders, target: 450, step: 25, noise: 10),
                avgWaitTime: drift(current: next.avgWaitTime, target: 8, step: 1, noise: 2),
                fulfillmentRate: drift(current: next.fulfillmentRate, target: 99.0, step: 0.5, noise: 0.2),
                surgeActive: false // Explicitly resolve surge if we hit normal params
            )
            
        case .surge:
            // Ramp towards Crisis
            // Orders: Target ~1500
            // WaitTime: Target ~45m
            next = OpsSignal(
                activeOrders: drift(current: next.activeOrders, target: 1500, step: 60, noise: 20),
                avgWaitTime: drift(current: next.avgWaitTime, target: 45, step: 3, noise: 1),
                fulfillmentRate: drift(current: next.fulfillmentRate, target: 85.0, step: 1.0, noise: 0.5),
                surgeActive: next.avgWaitTime > 30 // Auto-trigger flag when bad enough
            )
        }
        
        currentSignal = next
        signalPublisher.send(next)
    }
    
    // MARK: - Math Helpers
    
    private func drift(current: Int, target: Int, step: Int, noise: Int) -> Int {
        let direction = target > current ? 1 : -1
        // If close enough, just fluctuate
        if abs(target - current) < step {
            return target + Int.random(in: -noise...noise)
        }
        return current + (step * direction) + Int.random(in: -noise...noise)
    }
    
    private func drift(current: Double, target: Double, step: Double, noise: Double) -> Double {
        let direction = target > current ? 1.0 : -1.0
        if abs(target - current) < step {
            return target + Double.random(in: -noise...noise)
        }
        let newValue = current + (step * direction) + Double.random(in: -noise...noise)
        return min(max(newValue, 0), 100) // Clamp percentages
    }
}
