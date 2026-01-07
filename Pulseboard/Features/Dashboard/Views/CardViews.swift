import SwiftUI

// MARK: - Reusable Styles (Design System)

// Assuming DesignSystem.swift exists from previous steps.

struct BlockCardStyle: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func blockStyle(color: Color) -> some View {
        modifier(BlockCardStyle(color: color))
    }
}

// MARK: - Component Definitions

// MARK: - Component Definitions

struct OrderStatusCard: View {
    var isSurge: Bool = false
    
    // Left: VIBRANT PEACH section
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("ACTIVE ORDERS")
                   .font(.system(size: 10, weight: .bold))
                   .tracking(1)
                   .foregroundStyle(DesignSystem.Colors.textDark.opacity(0.7))
                
                Text(isSurge ? "High volume detected." : "Live volume from all zones.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(DesignSystem.Colors.textDark)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 6)
                
                Spacer()
                
                Text("1,230")
                    // Surge: Slightly heavier font
                    .font(.system(size: 52, weight: isSurge ? .bold : .medium, design: .rounded))
                    .kerning(-1)
                    .foregroundStyle(DesignSystem.Colors.textDark)
                    // Surge: Numeric transition
                    .contentTransition(.numericText())
                    .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isSurge)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DesignSystem.Colors.peach)
            
            // Right: Ticker / Trend
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.title2)
                        .foregroundStyle(DesignSystem.Colors.peach)
                }
                Spacer()
            }
            .padding(16)
            .frame(width: 80)
            .background(DesignSystem.Colors.cardSurfaceLighter)
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct FulfillmentCard: View {
    // The "Hollow Ring" Card
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Text("FULFILLMENT")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(DesignSystem.Colors.textSecondary)
                
                Text("98% of orders are delivered on time.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(20)
            
            Spacer()
            
            // Ring
            ZStack {
                Circle()
                    .stroke(DesignSystem.Colors.cardSurfaceLighter, lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: 0.85)
                    .stroke(DesignSystem.Colors.lavender, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("98%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
            }
            .frame(width: 90, height: 90)
            .padding(24)
        }
        .frame(height: 160)
        .blockStyle(color: DesignSystem.Colors.cardSurface)
    }
}

struct FleetStatusCards: View {
    var isSurge: Bool = false
    
    // The "Triple Block" Row
    var body: some View {
        HStack(spacing: 12) {
            FleetBlock(title: "ONLINE", value: "38%", bg: DesignSystem.Colors.cyan, fg: DesignSystem.Colors.textDark)
                // Surge: Scale up + Stronger shadow
                .scaleEffect(isSurge ? 1.02 : 1.0)
                .shadow(color: isSurge ? DesignSystem.Colors.cyan.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isSurge)
            
            FleetBlock(title: "IDLE", value: "39%", bg: DesignSystem.Colors.softBlue, fg: DesignSystem.Colors.textDark)
                // Surge: De-emphasize
                .opacity(isSurge ? 0.7 : 1.0)
                .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isSurge)
            
            FleetBlock(title: "OFFLINE", value: "23%", bg: DesignSystem.Colors.offWhite, fg: DesignSystem.Colors.textDark)
                // Surge: De-emphasize
                .opacity(isSurge ? 0.7 : 1.0)
                .animation(.spring(response: 0.45, dampingFraction: 0.85), value: isSurge)
        }
        .frame(height: 110)
    }
}

struct FleetBlock: View {
    let title: String
    let value: String
    let bg: Color
    let fg: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(fg)
            Spacer()
            Text(title)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(fg.opacity(0.7))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bg)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct SurgeAlertCard: View {
    @State private var isPulsing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("SURGE DETECTED", systemImage: "bolt.fill")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(DesignSystem.Colors.peach)
                    // Micro-interaction: Icon Pulse
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isPulsing)
                
                Spacer()
                
                // Live Indicator
                Circle()
                    .fill(DesignSystem.Colors.peach)
                    .frame(width: 8, height: 8)
                    .opacity(isPulsing ? 1.0 : 0.3)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
            }
            
            Text("High Demand Zone Active")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            
            Text("Wait times > 45min due to rain.")
                .font(.subheadline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .padding(20)
        .frame(height: 140)
        .blockStyle(color: DesignSystem.Colors.cardSurfaceLighter)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DesignSystem.Colors.peach, lineWidth: 2)
                .opacity(isPulsing ? 1.0 : 0.4) // Breathing border
                .scaleEffect(isPulsing ? 1.01 : 1.0) // Subtle breathing scale
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isPulsing)
        )
        .onAppear {
            isPulsing = true
        }
        .onDisappear {
            isPulsing = false
        }
    }
}

struct LiveZonesCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("LIVE ZONES")
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
                .padding(20)
            
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "map.fill")
                    .font(.largeTitle)
                    .foregroundStyle(DesignSystem.Colors.textSecondary.opacity(0.1))
                Spacer()
            }
            Spacer()
        }
        .frame(height: 140)
        .background(DesignSystem.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
