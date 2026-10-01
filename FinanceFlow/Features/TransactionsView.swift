import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject private var store: FinanceStore
    @State private var query = ""
    @State private var kind: TransactionKind?
    @State private var showAdd = false
    private var results: [FinanceTransaction] { store.transactions.filter { (query.isEmpty || $0.title.localizedCaseInsensitiveContains(query) || $0.category.localizedCaseInsensitiveContains(query)) && (kind == nil || $0.kind == kind) } }
    var body: some View { NavigationStack { ZStack { ScreenBackground(); List { Section { Picker("Type", selection: $kind) { Text("All activity").tag(TransactionKind?.none); Text("Expenses").tag(TransactionKind?.expense); Text("Income").tag(TransactionKind?.income) }.pickerStyle(.segmented).listRowBackground(Color.clear) } ; Section("\(results.count) transactions") { ForEach(results) { TransactionRow(transaction: $0).listRowBackground(Color.white.opacity(0.06)) } } }.scrollContentBackground(.hidden).searchable(text: $query, prompt: "Search transactions") }.navigationTitle("Activity").toolbar { Button { showAdd = true } label: { Image(systemName: "plus.circle.fill") } }.sheet(isPresented: $showAdd) { AddTransactionView() } } }
}

struct AddTransactionView: View {
    @EnvironmentObject private var store: FinanceStore
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var kind: TransactionKind = .expense
    var body: some View { NavigationStack { Form { Section("Transaction") { Picker("Type", selection: $kind) { Text("Expense").tag(TransactionKind.expense); Text("Income").tag(TransactionKind.income) }.pickerStyle(.segmented); TextField("What was it?", text: $title); TextField("Amount", text: $amount).keyboardType(.decimalPad); TextField("Category", text: $category) } Section { Button("Save transaction") { guard let value = Decimal(string: amount), value > 0, !title.isEmpty else { return }; store.add(FinanceTransaction(title: title, amount: value, category: category, kind: kind)); dismiss() }.frame(maxWidth: .infinity).fontWeight(.bold) } }.navigationTitle("New transaction").toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } } } }
}
