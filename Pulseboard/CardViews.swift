import SwiftUI

// MARK: - Block Card Modifier
struct BlockCardStyle: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

extension View {
    func blockStyle(color: Color) -> some View {
        modifier(BlockCardStyle(color: color))
    }
}

// MARK: - Components

struct OrderStatusCard: View {
    // The "Peach Split" Card
    var body: some View {
        HStack(spacing: 0) {
            // Left: VIBRANT PEACH section
            VStack(alignment: .leading, spacing: 4) {
                Text("ACTIVE ORDERS")
                   .font(.system(size: 10, weight: .bold))
                   .tracking(1)
                   .foregroundStyle(DesignSystem.Colors.textDark.opacity(0.7))
                
                Text("Said speed was very important to operations.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(DesignSystem.Colors.textDark)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 10)
                
                Spacer()
                
                Text("1,230")
                    .font(.system(size: 52, weight: .medium, design: .rounded)) // Matches the "75.5%" look
                    .kerning(-1)
                    .foregroundStyle(DesignSystem.Colors.textDark)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DesignSystem.Colors.peach)
            
            // Right: DARK section
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
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct PerformanceMetricsCard: View {
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
                    .stroke(DesignSystem.Colors.cardSurfaceLighter, lineWidth: 24)
                
                Circle()
                    .trim(from: 0, to: 0.38) // 38% from ref, but we use logic
                    .stroke(DesignSystem.Colors.lavender, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("98%")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(DesignSystem.Colors.textPrimary)
            }
            .frame(width: 110, height: 110)
            .padding(24)
        }
        .frame(height: 180)
        .blockStyle(color: DesignSystem.Colors.cardSurface)
    }
}


struct FleetHealthCard: View {
    // The "Triple Block" Row
    var body: some View {
        HStack(spacing: 12) {
            // Block 1: Cyan
            FleetBlock(
                title: "ONLINE",
                value: "38%",
                bg: DesignSystem.Colors.cyan,
                fg: DesignSystem.Colors.textDark
            )
            
            // Block 2: Soft Blue
            FleetBlock(
                title: "IDLE",
                value: "39%",
                bg: DesignSystem.Colors.softBlue,
                fg: DesignSystem.Colors.textDark
            )
            
            // Block 3: White
            FleetBlock(
                title: "OFFLINE",
                value: "38%",
                bg: DesignSystem.Colors.offWhite,
                fg: DesignSystem.Colors.textDark
            )
        }
        .frame(height: 120)
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
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(fg)
            Spacer()
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(fg.opacity(0.8))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bg)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct SurgeInsightsCard: View {
    // High contrast alert
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("SURGE ACTIVE", systemImage: "bolt.fill")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(DesignSystem.Colors.peach)
                Spacer()
            }
            
            Text("High Demand Zone")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(DesignSystem.Colors.textPrimary)
            
            Text("Wait times +15m")
                .font(.subheadline)
                .foregroundStyle(DesignSystem.Colors.textSecondary)
        }
        .padding(20)
        .frame(height: 140)
        .blockStyle(color: DesignSystem.Colors.cardSurfaceLighter)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DesignSystem.Colors.peach, lineWidth: 2)
        )
    }
}

struct LiveOperationsMapCard: View {
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
                    .foregroundStyle(DesignSystem.Colors.textSecondary.opacity(0.2))
                Spacer()
            }
            Spacer()
        }
        .frame(height: 180)
        .background(DesignSystem.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
