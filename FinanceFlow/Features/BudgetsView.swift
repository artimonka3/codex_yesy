import SwiftUI

struct BudgetsView: View {
    @EnvironmentObject private var store: FinanceStore
    @State private var showAdd = false
    var body: some View { NavigationStack { ZStack { ScreenBackground(); ScrollView { VStack(alignment: .leading, spacing: 18) { Text("Give every ruble a purpose.").font(.title3.weight(.semibold)).foregroundStyle(.secondary); ForEach(store.budgets) { budget in BudgetCard(budget: budget) }; Button { showAdd = true } label: { Label("Create a budget", systemImage: "plus").frame(maxWidth: .infinity).padding().background(.mint, in: RoundedRectangle(cornerRadius: 16)).foregroundStyle(.black).fontWeight(.bold) } }.padding(20) } }.navigationTitle("Spending plan").sheet(isPresented: $showAdd) { AddBudgetView() } } }
}

struct BudgetCard: View {
    @EnvironmentObject private var store: FinanceStore
    let budget: Budget
    var body: some View { let spent = FinanceCalculator.spent(in: budget.category, transactions: store.transactions); let progress = FinanceCalculator.budgetProgress(budget, transactions: store.transactions); VStack(alignment: .leading, spacing: 14) { HStack { Text(budget.category).font(.headline); Spacer(); Text("\(Int((progress as NSDecimalNumber).doubleValue * 100))% used").foregroundStyle(progress > 0.85 ? .orange : .mint).font(.subheadline.weight(.bold)) }; ProgressView(value: min((progress as NSDecimalNumber).doubleValue, 1)).tint(progress > 0.85 ? .orange : .mint).scaleEffect(y: 1.6); HStack { Text("Spent \(spent.rubles)").foregroundStyle(.secondary); Spacer(); Text("of \(budget.limit.rubles)").foregroundStyle(.secondary) } .font(.caption) }.padding(18).background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20)) }
}

struct AddBudgetView: View { @EnvironmentObject private var store: FinanceStore; @Environment(\.dismiss) private var dismiss; @State private var category = ""; @State private var limit = ""; var body: some View { NavigationStack { Form { TextField("Category", text: $category); TextField("Monthly limit", text: $limit).keyboardType(.decimalPad); Button("Create budget") { guard let value = Decimal(string: limit), value > 0, !category.isEmpty else { return }; store.addBudget(category: category, limit: value); dismiss() }.frame(maxWidth: .infinity) }.navigationTitle("New budget").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } } } }
