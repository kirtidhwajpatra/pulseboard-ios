import SwiftUI

struct PulseboardView: View {
    // MVVM: ViewModel injection
    @StateObject private var viewModel = PulseboardViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Mode Switcher (Binding to ViewModel)
                        Picker("Intent Mode", selection: Binding(
                            get: { viewModel.intentMode },
                            set: { viewModel.setModeManually($0) }
                        )) {
                            ForEach(IntentMode.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top)
                        .colorScheme(.dark)
                        
                        // Content Composition
                        // Surge: Compression Layout (tighter spacing)
                        VStack(spacing: viewModel.intentMode == .surge ? 10 : 16) {
                            dashboardContent(for: viewModel.intentMode)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: viewModel.intentMode)
                        
                        // 🛠 DevTools Panel
                        devToolsPanel()
                            .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("Pulseboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                     Circle()
                        .fill(DesignSystem.Colors.peach)
                        .frame(width: 28, height: 28)
                        .overlay(Text("4").font(.caption2).bold().foregroundStyle(.black))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - DevTools
    @ViewBuilder
    private func devToolsPanel() -> some View {
        VStack(spacing: 12) {
            Text("SIMULATION CONTROLS")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .tracking(2)
            
            HStack(spacing: 16) {
                Button(action: { viewModel.toggleSimulation() }) {
                    Label(viewModel.isSimulating ? "PAUSE SIMULATION" : "START SIMULATION", systemImage: viewModel.isSimulating ? "pause.fill" : "play.fill")
                        .font(.caption.bold())
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(DesignSystem.Colors.cardSurfaceLighter)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(20)
        .background(DesignSystem.Colors.cardSurface.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func dashboardContent(for intent: IntentMode) -> some View {
        let isSurge = intent == .surge
        
        switch intent {
        case .peak:
            OrderStatusCard(count: viewModel.signal.activeOrders, isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            FleetStatusCards(isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            FulfillmentCard()
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            
        case .lowActivity:
            FulfillmentCard()
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            FleetStatusCards(isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            LiveZonesCard()
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            
        case .surge:
            SurgeAlertCard()
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            OrderStatusCard(count: viewModel.signal.activeOrders, isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            FleetStatusCards(isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
    }
}

#Preview {
    PulseboardView()
}
