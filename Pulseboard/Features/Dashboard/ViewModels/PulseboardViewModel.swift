import SwiftUI
import Combine

// MARK: - ViewModel

final class PulseboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var signal: OpsSignal
    @Published var intentMode: IntentMode
    @Published var isSimulating = false
    
    // MARK: - Dependencies
    private let simulator = SignalSimulator()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(signal: OpsSignal = .initial) {
        self.signal = signal
        self.intentMode = IntentResolver.resolve(from: signal)
        
        // Bind Simulator -> ViewModel
        simulator.signalPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] newSignal in
                self?.updateSignal(newSignal)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Simulation Controls
    
    func toggleSimulation() {
        isSimulating.toggle()
        if isSimulating {
            simulator.start()
        } else {
            simulator.stop()
        }
    }
    
    // Manual triggers removed - Logic is now autonomous.
    
    // MARK: - Intents (User Actions / System Events)
    
    /// Updates the operational signal (Simulating backend push)
    func updateSignal(_ newSignal: OpsSignal) {
        self.signal = newSignal
        
        // NOTE: In Simulation Mode, we let logic drive intent automatically
        if isSimulating {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.intentMode = IntentResolver.resolve(from: newSignal)
            }
        }
    }
    
    /// Manual override for Demo purposes
    func setModeManually(_ mode: IntentMode) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            self.intentMode = mode
            // Update signal to match logic, ensuring consistency
            self.signal = IntentResolver.simulateSignal(for: mode)
        }
    }
}

// MARK: - Logic Helper (Private or Internal)

struct IntentResolver {
    
    /// Pure function: Signal -> Intent
    static func resolve(from signal: OpsSignal) -> IntentMode {
        if signal.surgeActive || signal.avgWaitTime > 25 {
            return .surge
        }
        if signal.activeOrders > 800 {
            return .peak
        }
        return .lowActivity
    }
    
    /// Reverse mapping for Demo: Intent -> Simulated Signal
    static func simulateSignal(for mode: IntentMode) -> OpsSignal {
        switch mode {
        case .peak:
            return OpsSignal(activeOrders: 1200, avgWaitTime: 18, fulfillmentRate: 95.0, surgeActive: false)
        case .lowActivity:
            return OpsSignal(activeOrders: 200, avgWaitTime: 8, fulfillmentRate: 99.9, surgeActive: false)
        case .surge:
            return OpsSignal(activeOrders: 1500, avgWaitTime: 45, fulfillmentRate: 88.0, surgeActive: true)
        }
    }
}
