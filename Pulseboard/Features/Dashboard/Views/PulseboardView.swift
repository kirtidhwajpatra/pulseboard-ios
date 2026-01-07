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
    
    @ViewBuilder
    private func dashboardContent(for intent: IntentMode) -> some View {
        let isSurge = intent == .surge
        
        switch intent {
        case .peak:
            OrderStatusCard(isSurge: isSurge)
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
            OrderStatusCard(isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
            FleetStatusCards(isSurge: isSurge)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
    }
}

#Preview {
    PulseboardView()
}
