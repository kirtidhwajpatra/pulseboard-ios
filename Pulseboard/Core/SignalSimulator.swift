import Foundation
import Combine

class SignalSimulator {
    let signalPublisher = PassthroughSubject<OpsSignal, Never>()
    
    private var timer: Timer?
    private var currentSignal: OpsSignal
    
    // Lifecycle Simulation
    private enum SimPhase {
        case normal
        case ramping // Simulating Rush Hour starting
        case cooling // Simulating Rush Hour ending
    }
    
    private var phase: SimPhase = .normal
    private var phaseDuration: TimeInterval = 0
    
    init(initialSignal: OpsSignal = .initial) {
        self.currentSignal = initialSignal
    }
    
    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func tick() {
        // 1. Update Lifecycle Phase
        phaseDuration += 2.0
        updatePhase()
        
        // 2. Drift Data based on Phase
        let prevSignal = currentSignal
        var next = driftSignal(prev: prevSignal, phase: phase)
        
        // 3. Detect Surge
        let isSurge = SurgeDetector.evaluate(current: next, previous: prevSignal)
        
        // 4. Finalize
        next = OpsSignal(
            activeOrders: next.activeOrders,
            avgWaitTime: next.avgWaitTime,
            fulfillmentRate: next.fulfillmentRate,
            surgeActive: isSurge
        )
        
        currentSignal = next
        signalPublisher.send(next)
    }
    
    private func updatePhase() {
        // Cycle: Normal(10s) -> Ramping(15s) -> Cooling(10s) -> Repeat
        switch phase {
        case .normal:
            if phaseDuration > 10 {
                phase = .ramping
                phaseDuration = 0
                print("SIMULATOR: Entering Ramping Phase")
            }
        case .ramping:
            if phaseDuration > 16 {
                phase = .cooling
                phaseDuration = 0
                print("SIMULATOR: Entering Cooling Phase")
            }
        case .cooling:
            if phaseDuration > 10 {
                phase = .normal
                phaseDuration = 0
                print("SIMULATOR: Entering Normal Phase")
            }
        }
    }
    
    private func driftSignal(prev: OpsSignal, phase: SimPhase) -> OpsSignal {
        switch phase {
        case .normal:
            // Drift towards Baseline
            return OpsSignal(
                activeOrders: drift(current: prev.activeOrders, target: 450, step: 30, noise: 15),
                avgWaitTime: drift(current: prev.avgWaitTime, target: 6, step: 1, noise: 1),
                fulfillmentRate: drift(current: prev.fulfillmentRate, target: 99.0, step: 0.5, noise: 0.2),
                surgeActive: false // Placeholder, overwritten by detector
            )
            
        case .ramping:
            // Simulate Rush Hour: Orders UP, Wait UP, Fulfillment DOWN
            return OpsSignal(
                activeOrders: drift(current: prev.activeOrders, target: 1600, step: 80, noise: 20),
                avgWaitTime: drift(current: prev.avgWaitTime, target: 40, step: 3, noise: 1),
                fulfillmentRate: drift(current: prev.fulfillmentRate, target: 88.0, step: 1.0, noise: 0.5),
                surgeActive: false
            )
            
        case .cooling:
            // Recovery
            return OpsSignal(
                activeOrders: drift(current: prev.activeOrders, target: 450, step: 60, noise: 20),
                avgWaitTime: drift(current: prev.avgWaitTime, target: 6, step: 2, noise: 1),
                fulfillmentRate: drift(current: prev.fulfillmentRate, target: 99.0, step: 1.0, noise: 0.2),
                surgeActive: false
            )
        }
    }
    
    private func drift(current: Int, target: Int, step: Int, noise: Int) -> Int {
        let direction = target > current ? 1 : -1
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
        return min(max(newValue, 0), 100)
    }
}
