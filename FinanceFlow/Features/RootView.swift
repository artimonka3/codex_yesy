import SwiftUI
import Foundation

struct RootView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            DashboardView().tabItem { Label("Overview", systemImage: "house.fill") }.tag(0)
            TransactionsView().tabItem { Label("Activity", systemImage: "list.bullet") }.tag(1)
            BudgetsView().tabItem { Label("Plan", systemImage: "chart.pie.fill") }.tag(2)
            InsightsView().tabItem { Label("Insights", systemImage: "sparkles") }.tag(3)
        }
        .tint(.mint)
    }
}

struct ScreenBackground: View {
    var body: some View {
        LinearGradient(colors: [Color(red: 0.035, green: 0.055, blue: 0.09), Color(red: 0.055, green: 0.12, blue: 0.14)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

extension Decimal {
    var rubles: String { (self as NSDecimalNumber).doubleValue.formatted(.currency(code: "RUB").precision(.fractionLength(0))) }
}
