import SwiftUI

@main
struct FinanceFlowApp: App {
    @StateObject private var store = FinanceStore()
    var body: some Scene {
        WindowGroup { RootView().environmentObject(store).preferredColorScheme(.dark) }
    }
}
