import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: FinanceStore
    @State private var showAdd = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        header
                        balanceCard
                        HStack(spacing: 12) {
                            statCard(title: "Income", value: store.summary.income.rubles, icon: "arrow.down.left", color: .mint)
                            statCard(title: "Spent", value: store.summary.expenses.rubles, icon: "arrow.up.right", color: .orange)
                        }
                        spendingSection
                        recentSection
                    }.padding(.horizontal, 20).padding(.bottom, 28)
                }
            }
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button { showAdd = true } label: { Image(systemName: "plus").fontWeight(.bold).padding(8).background(.mint, in: Circle()).foregroundStyle(.black) } } }
            .sheet(isPresented: $showAdd) { AddTransactionView() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Good evening, Alex").font(.title2.weight(.bold))
            Text(store.selectedPeriod).foregroundStyle(.secondary)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(.top, 10)
    }
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label("TOTAL BALANCE", systemImage: "wallet.pass.fill").font(.caption.weight(.bold)).foregroundStyle(.white.opacity(0.68))
            Text(store.summary.balance.rubles).font(.system(size: 36, weight: .bold, design: .rounded)).contentTransition(.numericText())
            HStack { Image(systemName: "arrow.up.right"); Text("+12.4% vs last month").font(.subheadline.weight(.semibold)); Spacer(); Image(systemName: "chevron.right") }.foregroundStyle(.mint)
        }
        .padding(22).background(LinearGradient(colors: [.teal.opacity(0.72), .indigo.opacity(0.78)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 28))
        .overlay(alignment: .topTrailing) { Circle().fill(.white.opacity(0.12)).frame(width: 130).offset(x: 40, y: -45) }
    }
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 13) { Image(systemName: icon).foregroundStyle(color).padding(9).background(color.opacity(0.15), in: Circle()); Text(title).font(.caption).foregroundStyle(.secondary); Text(value).font(.headline.weight(.bold)).lineLimit(1).minimumScaleFactor(0.7) }
            .frame(maxWidth: .infinity, alignment: .leading).padding(16).background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
    }
    private var spendingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack { Text("Spending plan").font(.title3.weight(.bold)); Spacer(); Text("See all").font(.subheadline).foregroundStyle(.mint) }
            ForEach(store.budgets.prefix(2)) { budget in
                let spent = FinanceCalculator.spent(in: budget.category, transactions: store.transactions)
                let progress = FinanceCalculator.budgetProgress(budget, transactions: store.transactions)
                VStack(alignment: .leading, spacing: 9) { HStack { Label(budget.category, systemImage: categoryIcon(budget.category)); Spacer(); Text("\(spent.rubles) / \(budget.limit.rubles)").font(.caption).foregroundStyle(.secondary) }; ProgressView(value: min((progress as NSDecimalNumber).doubleValue, 1)).tint(progress > 0.85 ? .orange : .mint) }
                    .padding(15).background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
            }
        }
    }
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) { Text("Recent activity").font(.title3.weight(.bold)); ForEach(store.transactions.prefix(3)) { TransactionRow(transaction: $0) } }
    }
    private func categoryIcon(_ name: String) -> String { ["Food": "fork.knife", "Transport": "car.fill", "Fun": "gamecontroller.fill"][name, default: "circle.fill"] }
}

struct TransactionRow: View {
    let transaction: FinanceTransaction
    var body: some View { HStack(spacing: 13) { Image(systemName: transaction.kind == .income ? "arrow.down.left" : "arrow.up.right").foregroundStyle(transaction.kind == .income ? .mint : .orange).frame(width: 40, height: 40).background(.white.opacity(0.09), in: Circle()); VStack(alignment: .leading, spacing: 3) { Text(transaction.title).fontWeight(.semibold); Text(transaction.category + " · " + transaction.date.formatted(date: .abbreviated, time: .omitted)).font(.caption).foregroundStyle(.secondary) }; Spacer(); Text((transaction.kind == .income ? "+" : "−") + transaction.amount.rubles).fontWeight(.bold).foregroundStyle(transaction.kind == .income ? .mint : .primary) }.padding(.vertical, 4) }
}
