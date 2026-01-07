import SwiftUI

struct PulseboardView: View {
    @StateObject private var dashboardState = DashboardState()
    
    // Custom Init to set NavBar appearance
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                DesignSystem.Colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Debug Control (Subtle)
                        Picker("Intent Mode", selection: $dashboardState.activeMode.animation(.spring(response: 0.4, dampingFraction: 0.8))) {
                            ForEach(IntentMode.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .colorScheme(.dark) // Force dark mode for picker
                        
                        // Intent-based Layout
                        VStack(spacing: 16) { // Tighter spacing for block grid feel
                            switch dashboardState.activeMode {
                            case .peak:
                                renderPeakLayout()
                            case .lowActivity:
                                renderLowActivityLayout()
                            case .surge:
                                renderSurgeLayout()
                            }
                        }
                        .padding(.horizontal, 16)
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
                        .frame(width: 30, height: 30)
                        .overlay(Text("4").font(.caption).bold().foregroundStyle(.black))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Layout Composition
    
    @ViewBuilder
    private func renderPeakLayout() -> some View {
        // Peak: 3 Blocks Row + Peach Card
        FleetHealthCard() // The 3 blocks
            .transition(.move(edge: .top).combined(with: .opacity))
        
        OrderStatusCard() // The Peach Split
            .transition(.scale(scale: 0.98).combined(with: .opacity))
        
        PerformanceMetricsCard() // The Ring
            .transition(.scale(scale: 0.98).combined(with: .opacity))
    }
    
    @ViewBuilder
    private func renderLowActivityLayout() -> some View {
        PerformanceMetricsCard()
        FleetHealthCard()
        LiveOperationsMapCard()
    }
    
    @ViewBuilder
    private func renderSurgeLayout() -> some View {
        SurgeInsightsCard()
        OrderStatusCard()
        FleetHealthCard()
    }
}

#Preview {
    PulseboardView()
}
